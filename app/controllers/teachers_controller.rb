class TeachersController < ApplicationController
	before_action :authenticate_teacher!
	before_action :check_id, only: [:update]

	def check_id
		redirect_to root_path unless current_teacher.id = params[:id]
	end

	def edit
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


	private
	def teacher_params
		params.require(:teacher).permit!
	end
end
