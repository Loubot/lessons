class EventsController < ApplicationController
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
		if @event.update_attributes(event_params)
			flash[:success] = "Lesson updated successfully"
			redirect_to :back
		else
			flash[:danger] = "Couldn't save lesson #{@event.errors.full_messages}"
			redirect_to :back
		end
	end

	private

	def event_params
		params.require(:event).permit!
	end

	def format_time(params)
		date = params[:date]
		starttime = Time.zone.parse("#{date} #{params[:event]['start_time(5i)']}")
		endtime = Time.zone.parse("#{date} #{params[:event]['end_time(5i)']}")
		@event_params = { time_off: params[:event][:time_off], start_time: starttime, end_time: endtime, status: 'active', teacher_id: params[:event][:teacher_id]}
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