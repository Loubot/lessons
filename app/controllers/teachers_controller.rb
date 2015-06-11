class TeachersController < ApplicationController
	layout 'teacher_layout', except: [:show_teacher]
	before_action :authenticate_teacher!, except: [:show_teacher]
	before_action :check_id, except: [:add_map, :show_teacher, :modals, :get_locations, :get_subjects, :get_locations_price, :check_home_event]
	before_action :check_is_teacher, only: [:edit, :teachers_area, :qualification_form, :your_business, :change_profile_pic, :add_map ]
																					#[:show_teacher, :previous_lessons, :modals, :get_locations, :get_subjects, :get_locations_price, :check_home_event]
	
	include TeachersHelper

	
	def show_teacher
		@teacher = Teacher.includes(:events,:prices, :experiences,:subjects, :qualifications,:locations, :photos, :packages).find(params[:id])
		@subject = get_subject(params, @teacher.subjects)
		@event = Event.new
		@categories = Category.includes(:subjects).all
		# @subject = Subject.find(params[:subject_id])
		
		
		@reviews = @teacher.reviews.take(3)
		@locations = @teacher.locations
		@prices = @teacher.prices
		gon.profile_pic_url = @teacher.photos.find { |p| p.id == @teacher.profile }.avatar.url
		@profilePic = @teacher.photos.find { |p| p.id == @teacher.profile }.avatar.url
		gon.locations = @locations
		@photos = @teacher.photos.where.not(id: @teacher.profile)
		
		# @home_price = @prices.select { |p| p.subject_id == @subject.id && p.no_map == true }.first
		gon.events = public_format_times(@teacher.events) #teachers_helper
		gon.openingTimes = open_close_times(@teacher.opening) #teachers_helper
		gon.teacher_id = @teacher.id
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
		fresh_when [@teacher, @teacher.events.maximum(:updated_at)]
	end

	def qualification_form
		@context = current_teacher
		@qualifications = Qualification.where(teacher_id: current_teacher.id)
		@qualification = @context.qualifications.new
		fresh_when @qualifications
	end

	def your_business
		@teacher = Teacher.includes(:locations, :prices, :subjects, :grinds).find(params[:id])
		# @location = @teacher.locations.first
		@package = Package.new
		@grind = Grind.new
		@locations = @teacher.locations.reorder("created_at ASC")
		@subjects = @teacher.subjects
		gon.locations = @locations
		session[:map_id] = @locations.empty? ? 0 : @locations.last.id #store id for tabs
		# fresh_when [@locations.maximum(:updated_at), @teacher.subjects.maximum(:updated_at)]
	end

	def change_profile_pic
		@params = params
		current_teacher.update_attributes(profile: params[:picture_id])
		flash[:notice] = 'Profile picture updated'
		redirect_to :back
	end

	def teacher_subject_search
		@subjects = params[:search] == '' ? [] : Subject.where('name LIKE ?', "%#{params[:search]}%")
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

	def get_locations
		session[:teacher_id] = params[:subject][:teacher_id]
		session[:subject_id] = params[:subject][:id]
		p "session #{session[:subject_id]}"
		@teacher = Teacher.includes(:prices).find((params[:subject][:teacher_id]))
		
		if (@teacher.prices.any? { |p| p.no_map == true && p.subject_id == params[:subject][:id].to_i } && @teacher.prices.any? { |p| p.subject_id == params[:subject][:id].to_i && p.location_id != nil })
			render 'modals/payment_selections/_home_or_location.js.coffee'
		else
			@price = @teacher.prices.select { |p| p.no_map == true && p.subject_id == params[:subject][:id].to_i }[0]
			session[:price_id] = @price.id #price id for home booking
			@event = Event.new
			render 'modals/payment_selections/_return_home_checker.js.coffee'
		end
		
	end

	def get_subjects
		#location_choice =1 == home lesson
		#location_choice =2 == teachers location
		p "session #{session[:subject_id]}"
		@teacher = Teacher.includes(:locations, :prices).find(session[:teacher_id])
		if params[:location][:id].to_i == 1 #home lesson
			@price = @teacher.prices.select { |p| p.no_map == true && p.subject_id == session[:subject_id].to_i }[0]
			p "prices yoyo #{@price}"
			session[:price_id] = @price.id
			@event = Event.new
			render 'modals/payment_selections/_return_home_checker.js.coffee'
		else
			#only return locations that teacher teaches this subject at
			ids = @teacher.prices.map { |p| p.location_id if (p.subject_id == session[:subject_id].to_i && p.location_id != nil) }.compact
			p "ids #{ids}"
			# @locations = @teacher.locations.map { |l| l if ids.include?  l.id }
			@locations = @teacher.locations.find(ids)
			render 'modals/payment_selections/_return_locations.js.coffee'
		end
	end

	def get_locations_price
		p "yayd"
		@event = Event.new
		@subject_id = session[:subject_id]
		@rate = Price.where(
												teacher_id: session[:teacher_id], 
												subject_id: session[:subject_id], 
												location_id: params[:teachers_locations][:location_id])
		@teacher = Teacher.includes(:locations, :prices, :subjects).find(session[:teacher_id].to_i)
		session[:price_id] = @rate.first.id #store price id for later
		session[:location_id] = params[:teachers_locations][:location_id] #store location id for later
		
		render 'modals/payment_selections/_return_locations_price.js.coffee'
	end
		
	def check_home_event
		event = Event.student_do_single_booking(params)
		@price = Price.find(session[:price_id])
		if event.valid?
			@teacher = Teacher.find(session[:teacher_id])	# teacher not student		
			@event = event
			p "start time #{params[:start_time]}"
    	@cart = UserCart.home_booking_cart(params[:event], @price.price)
			p "event is valid!!!!!!!!!!"
		else
			p "event is not valid&&&&&&&&&&&&&&&&&&S"
			@event = event.errors.full_messages
		end
		render 'modals/payment_selections/_return_home_price.js.coffee'
		# redirect_to :back
	end	

	private
		def check_is_teacher
			if current_teacher.is_teacher != true
				flash[:danger] = "You are not authorised to view this page"
				redirect_to :back 
			end
		end

		def check_id
			if current_teacher.id != params[:id].to_i
				flash[:danger] = "You are not authorised to view this page"
				redirect_to root_path
			end 
		end

		def get_subject(params, subjects)
			if params.has_key?(:subject_id)
				@teacher.subjects.select { |s| s.id == params[:subject_id].to_i }.first
				
			else
				return subjects[0]
			end
		end #return subect to show_teacher

		def teacher_params
			params.require(:teacher).permit!
		end

		def addTime(params)
			opening = Time.zone.parse(params[:teacher]['opening(5i)'])
			closing = Time.zone.parse(params[:teacher]['closing(5i)'])
			returned_params = { opening: opening, closing: closing }
		end
end
