class QualificationsController < ApplicationController

	before_action :authenticate_teacher!

	def create
		@qualification = Qualification.new(qualification_params)
		if @qualification.save
			flash[:success] = 'Qualification saved'
			redirect_to :back
		else
			flash[:danger] = "Failed to save qualification #{@qualification.errors.full_messages}"
			redirect_to :back
		end
	end

	def update
		@qualification = Qualification.find(params[:id])
		if @qualification.update_attributes(qualification_params)
			flash[:success] = "Qualification updated successfully"
			redirect_to :back
		else
			flash[:danger] = "Failed to update qualification #{@qualification.errors.full_messages}"
			redirect_to :back
		end
	end

	def destroy
		@qualification = Qualification.find(params[:id])
		if @qualification.destroy
			flash[:success] = "Qualification successfully deleted"
			redirect_to :back
		else
			flash[:danger] = "Failed to delete qualification #{@qualification.errors.full_messages}"
			redirect_to :back
		end
	end

	private

		def qualification_params
			params.require(:qualification).permit!
		end
end
