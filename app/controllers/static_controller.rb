class StaticController < ApplicationController	

	include StaticHelper	
	
	def how_it_works

	end

	def mailing_list
		
	end

	def welcome		
		
	end	

	def learn

	end

	def teach

	end

	def add_to_list
		gb = Gibbon::API.new(ENV['_mail_chimp_api'], { :timeout => 15 })
		flash[:notice] = params
		if valid_email?(params[:email])
			begin
				gb.lists.subscribe({:id => ENV['_mail_chimp_list'], :email => {:email => params[:email] },:double_optin => false})
			rescue Gibbon::MailChimpError, StandardError => e
				flash[:danger] = e
			end
		end
		redirect_to :back
	end

	def subject_search
		@subjects = params[:search] == '' ? [] : Subject.where('name LIKE ?', "%#{params[:search]}%")
		render json: @subjects
	end

	def display_subjects
		
		teachers = get_search_results(params)
		@teachers = teachers.check_if_valid
	end

	def browse_categories
		@categories = Category.order(name: :asc)
	end

	private

		def valid_email?(email)
			valid_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
			email =~ valid_regex
		end		
end