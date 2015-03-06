class EventsController < ApplicationController
	include TeachersHelper
	include	EventsHelper
	before_action :authenticate_teacher!
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
		puts "vents controller/update params: #{params}"
		@event = Event.find(params[:id])
		start_time = (params[:event][:start_time].to_i) + 1.hours
		end_time = (params[:event][:end_time].to_i) + 1.hours

		respond_to do |format| 
			 if @event.update_attributes(start_time: Time.at(start_time), end_time: Time.at(end_time),
																title: params[:title])
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
	end

	# ajax event booking
	def create_event_and_book		
		
		@rate = params[:event][:rate].to_f #set instance variable of rate

		if params['Multiple'] == '1'
			if @teacher = studentDoMultipleBookings(params)
				
				render 'events/multiple_events.js.coffee'
			else
				puts @teacher
				return
			end
		else
			event_params = student_format_time(params[:event])
			p "event params #{event_params.inspect}"
			@event = Event.new(event_params)
			
			
			if @event.valid?
				@teacher = Teacher.find(params[:event][:teacher_id])	# teacher not student		
				@cart = UserCart.find_or_initialize_by(student_id: params[:event][:student_id])
				@cart.update_attributes(teacher_id: params[:event][:teacher_id],
																 params: event_params, teacher_email: @teacher.email,
																 student_email: current_teacher.email,
																 student_name: "#{current_teacher.full_name}",
																 subject_id: params[:event][:subject_id])
				@cart.save!
				p "cart  #{@cart.inspect}"
			else
				@teacher = @event.errors.full_messages
			end
		end
		
		
	end

	private

		def event_params(params)
			params.require(:event).permit!
		end

		
end