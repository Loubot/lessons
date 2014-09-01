class StaticController < ApplicationController
	
	def how_it_works

	end

	def mailing_list
		
	end

	def add_to_list
		gb = Gibbon::API.new("a54fa2423a373c73c8eff5e2f8c208d4-us8", { :timeout => 15 })
		flash[:notice] = params
		if valid_email?(params[:email])
			flash[:notice] = 'yep'
			begin
				gb.lists.subscribe({:id => 'e854603460', :email => {:email => params[:email] },:double_optin => false})
			rescue Gibbon::MailChimpError => e
				flash[:danger] = e
			end
		end
		redirect_to :back
	end

	def subject_search
		@subjects = params[:search] == '' ? [] : Subject.where('name ILIKE ?', "%#{params[:search]}%")
		render json: @subjects
	end

	def display_subjects
		@params = params
		@subject = params[:search_subjects] == '' ? [] : Subject.where('name ILIKE ?', "%#{params[:search_subjects]}%").first
		flash[:notice] = @subject.to_json
		if !params[:search_position].empty?
			if params[:sort_by] == 'Rate'
				@teachers = defined?(@subject.teachers) ? @subject.teachers.near(params[:search_position], 50).reorder('rate ASC')
					 : []
			else
				flash[:success] = 'b'
				@teachers = defined?(@subject.teachers) ? @subject.teachers.near(params[:search_position], 50).order('distance ASC') : []	
			end
		else
			@teachers = defined?(@subject.teachers) ? @subject.teachers : []
		end
		
	end

	private

	def valid_email?(email)
		valid_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
		email =~ valid_regex
	end
end
