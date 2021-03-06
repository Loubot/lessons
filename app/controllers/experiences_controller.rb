# == Schema Information
#
# Table name: experiences
#
#  id          :integer          not null, primary key
#  title       :string
#  description :text
#  teacher_id  :integer
#  start       :datetime
#  end_time    :datetime
#  present     :binary
#  created_at  :datetime
#  updated_at  :datetime
#

class ExperiencesController < ApplicationController

	before_action :authenticate_teacher!

	def create		
		@experience = Experience.new(experience_params)
		if @experience.save
			flash[:success] = "Work experience saved"
			redirect_to :back
		else
			flash[:danger] = "Couldn't save your work experience #{@experience.errors.full_messages}"
			redirect_to :back
		end
	end

	def update
		@experience = Experience.find(params[:id])
		if @experience.update_params(experience_params)
			flash[:success] = "Work experience updated successfully"
			redirect_to :back
		else
			flash[:danger] = "Couldn't save your work experience #{@experience.errors.full_messages}"
			redirect_to :back
		end
	end

	def destroy
		@experience = Experience.find(params[:id])
		if @experience.destroy
			flash[:success] = "Work experience deleted successfully"
			redirect_to :back
		else
			flash[:danger] = "Couldn't delete your work experience #{@experience.errors.full_messages}"
			redirect_to :back
		end
	end

	private
		def experience_params
			params.require(:experience).permit!
		end
end
