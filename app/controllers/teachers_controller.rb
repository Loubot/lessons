class TeachersController < ApplicationController
	layout 'teacher_layout', except: [:show_teacher]
	before_action :authenticate_teacher!, except: [:show_teacher]
	before_action :check_id, only: [:update]
	before_action :check_is_teacher, except: [:show_teacher, :previous_lessons]
	
	include TeachersHelper

	def check_is_teacher
		redirect_to root_path unless current_teacher.is_teacher == true	
	end

	def check_id
		redirect_to root_path unless current_teacher.id == params[:id].to_i
	end

	def show_teacher		
		@params = params
		@event = Event.new
		
		@subject = Subject.find(params[:subject_id])
		@teacher = Teacher.includes(:events,:prices, :experiences,:subjects, :qualifications, :reviews).find(params[:id])
		# gon.location= [@teacher.lat, @teacher.lon]
		if !current_teacher.locations.empty?
			gon.location = [current_teacher.locations.last.latitude, current_teacher.locations.last.longitude]
		else
			gon.location = [nil, nil]
		end
		gon.events = public_format_times(@teacher.events) #teachers_helper
		gon.openingTimes = open_close_times(@teacher.opening) #teachers_helper
		# @distance = @teacher.distance_to([51.886823, -8.472886],:km)
		pick_show_teacher_view(params[:id])		
	end

	def edit
		@context = Teacher.includes(:experiences,:subjects).find(params[:id])
		@photo = @context.photos.new
		#@context.profile == nil ? @profilePic = nil : @profilePic = Photo.find(@context.profile)
		@params = params
		@photos = @context.photos.all
		@experience = Experience.new
		@subjects = @context.subjects
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
	  	if @teacher.paypal_verify(params).success?
	  		flash[:success] = "Paypal email updated ok"
	  	else
	  		flash[:danger] = "That is not a valid Paypal merchant email"
	  	end
	  	redirect_to :back and return
	  else @teacher.update_attributes(teacher_params)
	  	flash[:success] = 'Details updated ok'
	  	redirect_to :back
	  end
	  @teacher.set_active	
		
	end

	def teachers_area
		@params = params
		@teacher = Teacher.includes(:events, :subjects, :prices).find(params[:id])
		gon.events = format_times(@teacher.events) #teachers_helper
		gon.openingTimes = open_close_times(@teacher.opening) #teachers_helper
		@event = @teacher.events.new
		@opening = Opening.find_or_create_by(teacher_id: current_teacher.id)

	end

	def qualification_form
		@context = current_teacher
		@qualifications = Qualification.where(teacher_id: current_teacher.id)
		@qualification = @context.qualifications.new
	end

	def your_location
		@teacher = current_teacher
		@location = Location.new
		if !current_teacher.locations.empty?
			gon.location = [current_teacher.locations.last.latitude, current_teacher.locations.last.longitude]
		else
			gon.location = [nil, nil]
		end
	end

	def change_profile_pic
		@params = params
		current_teacher.update_attributes(profile: params[:id])
		flash[:notice] = 'Profile picture updated'
		redirect_to :back
	end

	def teacher_subject_search
		@subjects = params[:search] == '' ? [] : Subject.where('name LIKE ?', "%#{params[:search]}%")
	end

	def previous_lessons
		if !current_teacher.is_teacher
			render layout: 'application'
		else 
			render layout: 'teacher_layout'
		end
	end

	def add_map
		@teacher = current_teacher
		p request.to_s

	end

	private
		def teacher_params
			params.require(:teacher).permit!
		end

		def addTime(params)
			opening = Time.zone.parse(params[:teacher]['opening(5i)'])
			closing = Time.zone.parse(params[:teacher]['closing(5i)'])
			returned_params = { opening: opening, closing: closing }
		end
end
