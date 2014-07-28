class OpeningsController < ApplicationController
	def create
		
		@opening = Opening.new(format_times(params))
		if @opening.save
			flash[:success] = "Opening times updated"
			redirect_to :back
		else
			flash[:danger] = "Can't update opening times #{@opening.errors.full_messages}"
			redirect_to :back
		end
	end

	def update
		@opening = Opening.find(params[:id])
		if @opening.update_attributes(format_times(params))
			flash[:success] = "Opening times updated"
			redirect_to :back
		else
			flash[:danger] = "Can't update opening times #{@opening.errors.full_messages}"
			redirect_to :back
		end
	end

	private
		def opening_params
			params.require(:opening).permit!
		end

		def format_times(params)
			date = Date.current()
			mon_open = Time.zone.parse("#{date} #{params[:opening]['mon_open(5i)']}")#
			mon_close = Time.zone.parse("#{date} #{params[:opening]['mon_close(5i)']}")
			return { teacher_id: params[:opening][:teacher_id], mon_open: mon_open, mon_close: mon_close }
		end
end