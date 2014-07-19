class ExperiencesController < ApplicationController

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
			rediret_to :back
		else
			flash[:danger] = "Couldn't save your work experience #{@experience.errors.full_messages}"
			rediret_to :back
		end
	end

	def destroy
		@experience = Experience.find(params[:id])
		if @experience.destroy
			flash[:success] = "Work experience deleted successfully"
			rediret_to :back
		else
			flash[:danger] = "Couldn't delete your work experience #{@experience.errors.full_messages}"
			rediret_to :back
		end
	end

	private
		def experience_params
			params.require(:experience).permit!
		end
end
