class EventsController < ApplicationController
	def create
		
		if params[:date].blank? 
			flash[:danger] = "Date can't be blank"
			redirect_to :back and return
		end
		save_params = format_time(params)
		@event = Event.new(save_params)
		if @event.save
			flash[:success] = "Event saved"
			redirect_to :back
		else
			flash[:danger] = "Not saved #{@event.errors.full_messages}"
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
		@event_params = { start_time: starttime, end_time: endtime, status: 'active', teacher_id: params[:event][:teacher_id]}
	end
end