class TeachersController < ApplicationController
	before_action :authenticate_teacher!
	before_action :check_id, only: [:update]
	include TeachersHelper

	def check_id
		redirect_to root_path unless current_teacher.id = params[:id]
	end

	def edit
		@context = context
		@photo = Photo.new
		@params = params
		@teacher = Teacher.find(current_teacher)
		
	end
	
	def update
		@teacher = Teacher.find(current_teacher)
		if @teacher.update_attributes(teacher_params)
			flash[:success] = 'Details updated ok'
			redirect_to :back
		end
	end

	def teachers_area
		@params = params
		@teacher = Teacher.find(current_teacher)
		@event = Event.new
		gon.events = format_times(Event.all)
	end



	private
		def teacher_params
			params.require(:teacher).permit!
		end


		def context 
			if params[:controller] == 'teachers'
				Teacher.find(params[:id])
			end
		end
end
