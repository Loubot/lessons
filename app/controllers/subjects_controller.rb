class SubjectsController < ApplicationController

	def create
		@subject = Subject.new(subject_params)
		if @subject.save
			flash[:success] = "Subject created successfully"
			redirect_to :back
		else
			flash[:danger] = "Couldn't create subject @subject.errors.full_messages"
			redirect_to :back
		end
	end

	def destroy
		@subject = Subject.find(params[:id])
		if @subject.destroy
			flash[:success] = "Subject deleted successfully"
			redirect_to :back
		else
			flash[:danger] = "Couldn't delete subject @subject.erros.full_messages"
			redirect_to :back
		end
	end

	private
		def subject_params
			params.require(:subject).permit!
		end
end
