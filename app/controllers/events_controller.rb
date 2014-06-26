class EventsController < ApplicationController
	def create
		
		save_params = format_time(params)
		@event = Event.new(save_params)
		if @event.save
			flash[:sucess] = "Event saved"
			redirect_to :back
		else
			flash[:danger] = "Not saved #{@event.errors.full_messages}"
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
		@event_params = { start_time: starttime, end_time: endtime, status: 'active'}
	end
end