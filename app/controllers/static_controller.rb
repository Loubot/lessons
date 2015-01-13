class StaticController < ApplicationController
	require 'will_paginate/array'	

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
		@subjects = params[:search] == '' ? [] : Subject.where('name ILIKE ?', "%#{params[:search]}%")
		render json: @subjects
	end

	def display_subjects
		require 'will_paginate/array' 
		#ids = Location.near('cork', 10).select('id').map(&:teacher_id)
		#Teacher.includes(:locations).where(id: ids)
		@subject = params[:search_subjects] == '' ? [] : Subject.where('name ILIKE ?', "%#{params[:search_subjects]}%").first

		ids = Location.near('cork', 10).select('id').map(&:teacher_id)
		@teachers = @subject.teachers.check_if_valid.includes(:locations).where(id: ids).paginate(page: params[:page])
		# teachers = get_search_results(params, @subject)
		
		# @teachers = !teachers.empty? ? teachers.paginate(:page => params[:page]) : []
	end

	def browse_categories
		@categories = Category.order(name: :asc)
	end

	# def refresh_welcome
	# 	render "static/partials/#{params[:page]}", :layout => false
		
	# end

	private

		def valid_email?(email)
			valid_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
			email =~ valid_regex
		end		
end