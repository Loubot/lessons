class TeachersController < ApplicationController
	before_action :authenticate_teacher!
	before_action :check_id, only: [:update]
	include TeachersHelper

	def check_id
		redirect_to root_path unless current_teacher.id = params[:id]
	end

	def edit
		@context = Teacher.find(current_teacher)
		@photo = @context.photos.new
		@params = params
		@photos = @context.photos.all
		@qualifications = Qualification.where(teacher_id: current_teacher.id)
		@qualification = @context.qualifications.new
		
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
		gon.events = format_times(@teacher.events)
		
		@event = @teacher.events.new
		
		
		gon.location = [@teacher.lat,@teacher.lon]
	end



	private
		def teacher_params
			params.require(:teacher).permit!
		end

end
