class StaticController < ApplicationController

	layout 'static_layout'

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
		@subjects = params[:search] == '' ? [] : Subject.where('name LIKE ?', "%#{params[:search]}%")
		render json: @subjects
	end

	def display_subjects
		@params = params
		@teachers = get_search_results(params)
		
	end

	private

	def valid_email?(email)
		valid_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
		email =~ valid_regex
	end
end
