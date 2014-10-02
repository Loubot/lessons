class EventsController < ApplicationController
	include TeachersHelper
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
		puts "//////////////#{params}"
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
		#student_format_time(params)
		@event = Event.new(student_format_time(params))
		if @event.valid?
			@teacher = Teacher.find(params[:id])
		else
			@teacher = @event.errors.full_messages
		end
		
	end

	private

		def event_params(params)
			params.require(:event).permit!
		end

		def format_time(params)
			date = params[:date]
			starttime = Time.zone.parse("#{date} #{params[:event]['start_time(5i)']}")
			endtime = Time.zone.parse("#{date} #{params[:event]['end_time(5i)']}")
			@event_params = { time_off: params[:event][:time_off], start_time: starttime,
											 end_time: endtime, status: 'active',
											  teacher_id: params[:event][:teacher_id]}
		end

		def student_format_time(params)
			date = params[:date]
			starttime = Time.zone.parse("#{date} #{params[:event]['start_time(4i)']}:#{params[:event]['start_time(5i)']}")
			p "$$$$$$$$$$$$ #{starttime}"
			endtime = Time.zone.parse("#{date} #{params[:event]['end_time(4i)']}:#{params[:event]['end_time(5i)']}")
			@event_params = { time_off: params[:event][:time_off], start_time: starttime,
											 end_time: endtime, status: 'active',
											  teacher_id: params[:event][:teacher_id]}

		end

		def doMultipleBookings(params)
			ids = []
			continue = true
			date = Date.parse(params[:date])
			startTime = Time.parse("#{date}, #{params[:event]['start_time(5i)']}")
			endTime = Time.parse("#{date}, #{params[:event]['end_time(5i)']}")
			puts startTime + 7.days
			puts endTime + 7.days
			weeks = params[:booking_length].to_i - 1
			for i in 0..weeks
				newStart = startTime + (i*7.days)
				newEnd = endTime + (i*7.days)
				e = Event.new(start_time: newStart, end_time: newEnd, status: 'active',
										 teacher_id: current_teacher.id)
				if e.save
					ids << e.id
				else 
					flash[:danger] = "There was a booking conflict #{e.errors.full_messages}"
					ids.each do |id|
						Event.find(id).destroy					
					end
					continue = false
					return
				end
				return unless continue
			end

		end
end