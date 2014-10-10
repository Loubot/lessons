class TeachersController < ApplicationController
	layout 'teacher_layout', except: [:show_teacher]
	before_action :authenticate_teacher!, except: [:show_teacher]
	before_action :check_id, only: [:update]
	before_action :check_is_teacher, except: [:show_teacher]
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
		@teacher = Teacher.find(params[:id])
		gon.location= [@teacher.lat, @teacher.lon]
		gon.events = public_format_times(@teacher.events)
		gon.openingTimes = open_close_times(@teacher.openings.first)
		@distance = @teacher.distance_to([51.886823, -8.472886],:km)
		pick_show_teacher_view(params[:id])		
	end

	def edit
		@context = Teacher.find(current_teacher)
		@photo = @context.photos.new
		#@context.profile == nil ? @profilePic = nil : @profilePic = Photo.find(@context.profile)
		@params = params
		@photos = @context.photos.all
		@experience = Experience.new
		@experiences = @context.experiences
		@subjects = @context.subjects
	end
	
	def update		
		@teacher = Teacher.find(current_teacher)
		if @teacher.update_attributes(teacher_params)
			flash[:success] = 'Details updated ok'
			
		end
		# if params[:teacher]['opening(5i)']
		# 	(teacher_params = addTime(params)) 
		# end
		redirect_to :back
		
	end

	def teachers_area
		@params = params
		@teacher = Teacher.find(current_teacher)
		gon.events = format_times(@teacher.events)
		gon.openingTimes = open_close_times(@teacher.openings.first)
		@event = @teacher.events.new
		@opening = checkOpeningExists()

	end

	def qualification_form
		@context = Teacher.find(current_teacher)
		@qualifications = Qualification.where(teacher_id: current_teacher.id)
		@qualification = @context.qualifications.new
	end

	def your_location
		@teacher = Teacher.find(current_teacher)
		gon.location = [@teacher.lat,@teacher.lon]
	end

	def change_profile_pic
		@params = params
		@teacher = Teacher.find(current_teacher)
		@teacher.update_attributes(profile: params[:id])
		flash[:notice] = 'Profile picture updated'
		redirect_to :back
	end

	def teacher_subject_search
		@subjects = params[:search] == '' ? [] : Subject.where('name LIKE ?', "%#{params[:search]}%")
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

		def checkOpeningExists	
			@opening = Opening.find_or_create_by(teacher_id: current_teacher.id)			
		end
end
