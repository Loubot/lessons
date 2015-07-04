class TeachersController < ApplicationController
	layout 'teacher_layout', except: [:show_teacher]
	before_action :authenticate_teacher!, except: [:show_teacher]
	before_action :check_id, except: [:add_map, :show_teacher, :modals, :get_locations, :get_subjects, :get_locations_price, :check_home_event]
	before_action :check_is_teacher, only: [:edit, :teachers_area, :qualification_form, :your_business, :change_profile_pic, :add_map ]
																					#[:show_teacher, :previous_lessons, :modals, :get_locations, :get_subjects, :get_locations_price, :check_home_event]
	
	include TeachersHelper

	
	def show_teacher
		@teacher = Teacher.includes(:events,:prices, :experiences,:subjects, :qualifications,:locations, :photos, :packages, :friendships).find(params[:id])

		if !@teacher.is_active #only show active teachers
			flash[:danger] = "This teacher has not completed their profile"
			redirect_to root_url and return
		end

		@subject = @teacher.subjects.find { |s| s.id == params[:subject_id].to_i }

		@subjects = get_subjects_with_prices(@teacher.subjects) #get only subjects with prices teachers_helper
		p "subject #{@subjects}"
		@event = Event.new
		@categories = Category.includes(:subjects).all
		# @subject = Subject.find(params[:subject_id])
		
		@teacher.increment!(:profile_views, by = 1)

		@reviews = @teacher.reviews.take(3)
		@locations = @teacher.locations

		@prices = @teacher.prices.where(subject_id: params[:subject_id])
		@home_prices = @prices.select { |p| p.no_map == true } #only home prices
		@location_prices = @prices.select { |p| p.no_map == false } #only location prices
		
		gon.profile_pic_url = @teacher.photos.find { |p| p.id == @teacher.profile }.avatar.url
		@profilePic = @teacher.photos.find { |p| p.id == @teacher.profile }.avatar.url
		gon.locations = @locations
		@photos = @teacher.photos.where.not(id: @teacher.profile)
		
		# @home_price = @prices.select { |p| p.subject_id == @subject.id && p.no_map == true }.first
		gon.events = public_format_times(@teacher.events) #teachers_helper
		gon.openingTimes = open_close_times(@teacher.opening) #teachers_helper
		gon.teacher_id = @teacher.id

		session[:subject_id ] = params[:subject_id] #set subject id to session for booking purposes

		pick_show_teacher_view(params[:id])		#teachers_helper teacher or student view

		# fresh_when([current_teacher,flash])		
	end

	def edit
		@teacher = Teacher.includes(:experiences,:subjects, :photos,:locations, :prices, :identities).find(params[:id])
		@photos = @teacher.photos
		# @photo = @context.photos.new
		#@context.profile == nil ? @profilePic = nil : @profilePic = Photo.find(@context.profile)
		@params = params

		gon.teacher_id = current_teacher.id

		@auths = ['facebook', 'google_oauth2', 'twitter', 'linkedin']
		
		@experience = Experience.new
		@subjects = @teacher.subjects

		# fresh_when([@teacher, @teacher.profile, @subjects.maximum(:updated_at),flash])
	end
	
	def update
		@teacher = current_teacher
		if params[:rate_select]
			@teacher.add_prices(params)
			@subjects = @teacher.subjects.includes(:prices)
			@params = params
		elsif params[:will_travel]
			@teacher.set_will_travel(params)
			@subjects = @teacher.subjects.includes(:prices)
			@params = params
		elsif params[:teacher][:paypal_email]
			bla = @teacher.paypal_verify(params)	  
	  	if bla.success?
	  		flash[:success] = "Paypal email updated ok"
	  	else
	  		p bla.inspect
	  		flash[:danger] = "Email or names provided incorrect or not a paypal merchant account."

	  	end
	  	redirect_to :back and return
	  else @teacher.update_attributes(teacher_params)
	  	flash[:success] = 'Details updated ok'
	  	redirect_to :back
	  end
	  @teacher.set_active	
		
	end

	def destroy
		redirect_to :back and return if !current_teacher.admin
		@teacher = Teacher.find(params[:id])
		if @teacher.destroy
			flash[:success] = "Teacher deleted"
		else
			flash[:danager] = "Couldn't delete teacher: #{@teacher.errors.full_messages}"
		end

		redirect_to :back
	end

	def teachers_area
		@params = params
		@teacher = Teacher.includes(:events, :subjects, :prices, :reviews).find(params[:id])

		if params[:zoom] == 'true'
			events = @teacher.events.where(student_id: params[:student_id])
			@friendships = @teacher.friendships.where(student_id: params[:student_id])
		else
			events = @teacher.events
			@friendships = @teacher.friendships
		end

		gon.events = format_times(events) #teachers_helper

		gon.openingTimes = open_close_times(@teacher.opening) #teachers_helper
		@event = @teacher.events.new
		@existing_events = @teacher.events.reject { |e| e.id == nil }
		@opening = Opening.find_or_create_by(teacher_id: current_teacher.id)
		# fresh_when [@teacher, flash, @teacher.events.maximum(:updated_at)]
	end

	def qualification_form
		@context = current_teacher
		@qualifications = Qualification.where(teacher_id: current_teacher.id)
		@qualification = @context.qualifications.new
		# fresh_when @qualifications
	end

	def your_business
		@teacher = Teacher.includes(:locations, :prices, :subjects).find(params[:id])
		@event = Event.new
		@package = Package.new		
		@grind = Grind.new
		@locations = @teacher.locations.reorder("created_at ASC")
		@subjects = @teacher.subjects
		gon.locations = @locations
		session[:map_id] = @locations.empty? ? 0 : @locations.last.id #store id for tabs
		@home_prices = @teacher.prices.select { |p| p.no_map == true } #only home prices
		@location_prices = @teacher.prices.select { |p| p.no_map == false } #only location prices
		# fresh_when [@locations.maximum(:updated_at), @teacher.subjects.maximum(:updated_at)]
	end

	def change_profile_pic
		@params = params
		current_teacher.update_attributes(profile: params[:picture_id])
		flash[:notice] = 'Profile picture updated'
		redirect_to :back
	end

	def teacher_subject_search
		@subjects = params[:search] == '' ? [] : Subject.where('name ILIKE ?', "%#{params[:search]}%")
	end

	def previous_lessons
		@categories = Category.all
		if !current_teacher.is_teacher
			render layout: 'application'
		else 
			render layout: 'teacher_layout'
		end
	end

	def add_map
		@teacher = current_teacher
		@id = session[:map_id].to_i + 1 #set id for new tabs
		@location = Location.new
		p request.to_s

	end	

	def create_new_subject #render modal content		
		@subject = Subject.new
		@categories = Category.all		
	end	

	def invite_students
		# p "root_url #{root_url}"
		if valid_email?(params[:teacher][:recipient_email])
			MembershipMailer.delay.send_invite_to_student(current_teacher, params[:teacher][:recipient_email])
			flash[:success] = "Invite sent ok to #{params[:teacher][:recipient_email]}"
		else
			flash[:danger] = "Not a valid email address"
		end
		redirect_to :back
	end

	private
		def check_is_teacher
			if current_teacher.is_teacher != true
				flash[:danger] = "You are not authorised to view this page"
				redirect_to :back 
			end
		end

		def check_id
			if !current_teacher.admin
				if current_teacher.id != params[:id].to_i
					flash[:danger] = "You are not authorised to view this page"
					redirect_to root_path
				end 
			end
		end

		def teacher_params
			params.require(:teacher).permit!
		end

		def addTime(params)
			opening = Time.zone.parse(params[:teacher]['opening(5i)'])
			closing = Time.zone.parse(params[:teacher]['closing(5i)'])
			returned_params = { opening: opening, closing: closing }
		end
end
