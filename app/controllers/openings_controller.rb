class OpeningsController < ApplicationController

	before_action :authenticate_teacher!

	include OpeningsHelper

	def create
		
		@opening = Opening.new(format_times(params)) #openings_helper
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
end