class SubjectsController < ApplicationController
	def create
		@subject = Subject.new(subject_params)
		if @subject.save
			flash[:success] = "Subject created successfully"
			redirect_to :back
		else
			flash[:danger] = "Couldn't create subject #{@subject.errors.full_messages}"
			redirect_to :back
		end
	end

	def destroy
		@subject = Subject.find(params[:id])
		if @subject.destroy
			flash[:success] = "Subject deleted successfully"
			redirect_to :back
		else
			flash[:danger] = "Couldn't delete subject #{@subject.erros.full_messages}"
			redirect_to :back
		end
	end

	def subject_search
		#@subjects = Subject.all

		@subjects = params[:search] == '' ? [] : Subject.where('name ILIKE ?', "%#{params[:search]}%")
	end

	

	def add_subject_to_teacher
		if params[:teacher]
			@teacher = Teacher.find(current_teacher)
			@subject = Subject.find(params[:id])
			if !@teacher.subjects.include?(@subject)
				@teacher.subjects << @subject
				flash[:success] = "#{@subject.name} successfully added to your list of subjects"
			else
				flash[:danger] = "Subject already added"
			end
		else
			flash[:danger] = "No subject detected"
		end
		redirect_to :back
	end

	def remove_subject_from_teacher
		subject = Subject.find(params[:id])
		if current_teacher.subjects.destroy(subject)
			Price.remove_prices_after_subject_delete(subject.id, current_teacher.id)
			flash[:success] = "#{subject.name} deleted from your list of subjects"
		else
			flash[:danger] = "Couldn't remove subject"
		end
		redirect_to :back
	end

	private
		def subject_params
			params.require(:subject).permit!
		end
end
