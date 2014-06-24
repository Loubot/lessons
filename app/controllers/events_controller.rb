class EventsController < ApplicationController
	def create
		@event = Event.new(event_params)
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
end