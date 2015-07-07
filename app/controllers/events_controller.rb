class EventsController < ApplicationController
	include TeachersHelper
	include	EventsHelper
	before_action :authenticate_teacher!
	before_action :check_id, only: [:payless_booking]


	def create
		if params[:date].blank? 
			flash[:danger] = "Date can't be blank"
			redirect_to :back and return
		end

		if params['Multiple']
			doMultipleBookings(params)
			redirect_to :back and return
		end
		
		@event = Event.new(format_time(params))
		if @event.save
			flash[:success] = "Lesson created successfully"
			redirect_to :back
		else
			flash[:danger] = "Couldn't save lesson #{@event.errors.full_messages}"
			redirect_to :back
		end
		
	end


	def edit
		@event = Event.find(params[:id])
		@teacher = Teacher.find(current_teacher)
	end

	def update
		puts "vents controller/update params: #{params[:event]['status']}"
		@event = Event.find(params[:id])
		start_time = (params[:event][:start_time].to_i) + 1.hours
		end_time = (params[:event][:end_time].to_i) + 1.hours

		respond_to do |format| 
			 if @event.update_attributes(start_time: Time.at(start_time), end_time: Time.at(end_time),
																title: params[:title], status: params[:event][:status])
			 	format.json { render json: @event }
			 	#format.js
			 else
			 	flash[:danger] = "Couldn't update #{@event.errors.full_messages}"
			 	format.json { render json: @event.errors.full_messages, status: :unprocessable_entity }
			 end
		end
		
	end 

	def destroy
		Event.find(params[:id]).destroy
		redirect_to :back
	end

	# ajax event booking	

	def payless_booking #take booking without payment
		cart = UserCart.find(session[:cart_id])
		cart.update_attributes(status: 'owed')
		if !cart
			flash[:danger] = "Couldn't find your cart. Please try again"
			p "Payless booking. Couldn't find cart"
			redirect_to :back and return

		end

		p "payless booking found cart"
		case cart.booking_type #single, multiple, home, package
		when 'home'
			update_student_address(params)
			cart.update_attributes(address:params[:home_address])
			Event.delay.create_confirmed_events(cart, cart.status)

			TeacherMailer.delay.home_booking_mail_teacher(
			                                                cart
			                                              )
			TeacherMailer.delay.home_booking_mail_student(
			                                                cart
			                                              )

		when 'single'
			lesson_location = Location.find(session[:location_id]).name
			Event.create_confirmed_events(cart, cart.status) #Event model, checks if multiple or not

			TeacherMailer.delay.single_booking_mail_teacher(                                                
                                                
                                                      lesson_location,
                                                      cart                		                            
                    		                            )

    	TeacherMailer.delay.single_booking_mail_student(
                                                  
                                                      lesson_location,
                                                      cart
                                                    )


		when 'multiple'
			lesson_location = Location.find(session[:location_id]).name
			Event.delay.create_confirmed_events(cart, cart.status) #Event model, checks if multiple or not

			TeacherMailer.delay.single_booking_mail_teacher(                                                
                                                
                                                      lesson_location,
                                                      cart                		                            
                    		                            )

    	TeacherMailer.delay.single_booking_mail_student(
                                                  
                                                      lesson_location,
                                                      cart
                                                    )

		when 'package'

		end
		flash[:success] = "Your booking will be confirmed by email soon."
		redirect_to :back
	end

	private

		def event_params
			params.require(:event).permit!
		end

		def check_id

			if params[:id].to_i != current_teacher.id
				render status: 200, nothing: true
			end
		end #end of payless_booking

		
end