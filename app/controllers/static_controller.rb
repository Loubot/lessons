class StaticController < ApplicationController
	require 'will_paginate/array'	

	include StaticHelper


	# caches_page :teach, :learn, gzip: true

	# caches_action :welcome, layout: false, gzip: true

	before_filter :get_categories

	def get_categories
		# @categories = Category.includes(:subjects)
		@categories = Category.where(name: 'Music').order(name: :asc)
	end

	def landing_page
		render layout: 'landing_page_layout'

		

		# fresh_when flash
	end


	def how_it_works

	end

	def mailing_list
		
	end

	def welcome
		
		# fresh_when([current_teacher, flash])
	end	

	def learn
		render 'static/mobile_views/mobile_learn' if is_mobile?
		# fresh_when(:etag => ['learn-page', current_teacher, flash], :public => true)
	end

	def teach
		@teacher = Teacher.new email: params[:invited_email]
		render 'static/mobile_views/mobile_teach' if is_mobile?
		# fresh_when(:etag => ['teach-page', current_teacher, flash], :public => true)
	end

	def prices

	end

	def add_to_list
		gb = Gibbon::API.new(ENV['_mail_chimp_api'], { :timeout => 15 })
		
		if valid_email?(params[:email]) #applications_controller
			begin
				gb.lists.subscribe({
														:id => ENV['_mail_chimp_list'],
														 :email => {
																				:email => params[:email]																				
																				},
																				:merge_vars => { :FNAME => params[:name] },
															:double_optin => false
														})

				
				flash[:success] = "Thank you, your sign-up request was successful! Please check your e-mail inbox."
			rescue Gibbon::MailChimpError, StandardError => e
				
				flash[:danger] = e.to_s
			end
		else
			flash[:danger] = "Email not valid"
		end
		redirect_to :back
	end

	def subject_search
		@subjects = params[:search] == '' ? [] : Subject.where('name LIKE ?', "%#{params[:search]}%")
		render json: @subjects
		fresh_when [params[:search_subjects], params[:position]]
	end

	def display_subjects
		require 'will_paginate/array' 
		#ids = Location.near('cork', 10).select('id').map(&:teacher_id)
		#Teacher.includes(:locations).where(id: ids)
		@subjects = Subject.where('name LIKE ?', "%#{ params[:search_subjects] }%")
		@subject = @subjects.first
		if @subjects.empty?			
			@teachers = @subjects.paginate(page: params[:page])
		else			
			@teachers = get_search_results(params, @subjects)
			@teachers.paginate(page: params[:page])
			
		end
		# fresh_when [params[:search_subjects], params[:position]]
	end

	def grinds_search
		require 'will_paginate/array'
		@teachers = Teacher.includes(:grinds, :locations).where.not(grinds: { teacher_id: nil } )
		respond_to do |format|
			format.html{
				
				ids = @teachers.collect { |t| t.id }
				@locations = Location.where(teacher_id: ids)

				p "locations #{@locations.inspect}"
				gon.locations = @locations
				@subject = Subject.where('name LIKE ?', "%#{ params[:search_subejcts] }").first
				@teachers = @teachers.paginate(page: params[:page])
			}
			format.js{}
			format.json{
				render json: { teachers: @teachers }
			}
		end
	end

	def browse_categories
		# @categories = Category.order(name: :asc)
		@categories = Category.where(name: 'Music').order(name: :asc)
	end

	def refresh_welcome
		render "static/partials/#{params[:page]}", :layout => false
		
	end

	def new_registration
		@oauth = session['devise.facebook_data']
		@provider = session['devise.facebook_data']['provider'] == 'facebook' ? "facebook" : "Google"
		# @teacher = Teacher.find_or_initialize_by(email: @stuff['info']['email'])
	end

	def confirm_registration
		puts "facebook_data #{session['devise.facebook_data']}"
		@teacher = Teacher.from_omniauth(session['devise.facebook_data']) #method in the teacher model
		
		
		if params[:teacher].to_i == 2
			p "adasdfad"
		@teacher.update_attributes(is_teacher: false)
		p @teacher.inspect
			if @teacher.save
				@identity = @teacher.identities.create_with_omniauth(session['devise.facebook_data'])
				@identity.save!
				p "Identity #{@identity.inspect}"
				flash[:success] = "Registered as student successfully"
				sign_in @teacher
				session['devise.facebook_data'] = nil
				redirect_to root_url
			else
				flash[:danger] = "Registration failed: #{@teacher.errors.full_messages}"
				redirect_to :back
			end
		else
			@teacher.update_attributes(is_teacher: true)
			if @teacher.save
				@identity = @teacher.identities.create_with_omniauth(session['devise.facebook_data'])
				@identity.save!
				p "Identity #{@identity.inspect}"
				flash[:success] = "Registered as a teacher successfully"
				sign_in @teacher
				session['devise.facebook_data'] = nil
				redirect_to root_url
			else
				flash[:danger] = "Registraion failed #{@teacher.errors.full_messages}"
				redirect_to :back
			end
		end
	end

	def feedback
		if teacher_signed_in?
			if current_teacher.is_teacher
				render layout: 'teacher_layout'
			else
				render layout: 'application'
			end
			fresh_when [current_teacher, flash]
		else
			render layout: 'application'
		end
	end

	def send_feedback
		if valid_email?(params[:email])
			AdminMailer.delay.send_feedback_email(params)
			flash[:success] = "Feedback submitted successfully"
	  else
	  	flash[:danger] = "Email not valid"
	  end
    redirect_to :back
	end

	private

		
end