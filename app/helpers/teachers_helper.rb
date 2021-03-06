# == Schema Information
#
# Table name: teachers
#
#  id                     :integer          not null, primary key
#  first_name             :string
#  last_name              :string
#  overview               :text             default("")
#  created_at             :datetime
#  updated_at             :datetime
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string
#  last_sign_in_ip        :string
#  admin                  :boolean
#  profile                :integer
#  is_teacher             :boolean          default(FALSE), not null
#  paypal_email           :string           default("")
#  stripe_access_token    :string           default("")
#  is_active              :boolean          default(FALSE), not null
#  will_travel            :boolean          default(FALSE), not null
#  stripe_user_id         :string
#  address                :string           default("")
#  paid_up                :boolean          default(FALSE)
#  paid_up_date           :date
#  profile_views          :integer          default(0)
#

module TeachersHelper
	def format_times(events) #create array of events with times formatted correctly
		formatted_times = []
		events.each do |event|
			formatted_times << {
                          id: event.id, 
                          text: "#{event.title}<br>Payment: #{event.status}", 
                          textColor: 'white',
										      start_date: event.start_time.strftime('%Y-%m-%d %H:%M'), 
										      end_date: event.end_time.strftime('%Y-%m-%d %H:%M'), 
                          color:'#0E64A0',
										      teacher_id: event.teacher_id, 
                          description: event.teacher.first_name,
                          status: event.status							
										    }
		end
		formatted_times
	end

	def public_format_times(events) #return array of formatted times with name removed for privacy
		formatted_times = []
		events.each do |event|
			
			formatted_times << {
        id: event.id, 
        text: 'Booking', 
        textColor: 'white',
        start_date: event.start_time.strftime('%Y-%m-%d %H:%M'), 
        end_date: event.end_time.strftime('%Y-%m-%d %H:%M'),
        color:'#0E64A0',
        teacher_id: event.teacher_id
      }
		end
		formatted_times
	end

	def open_close_times(openings) #return formatted opening times
		begin
			[
				{ days: 1, zones: [0,openings.mon_open.strftime("%H").to_i * 60 +
					(openings.mon_open.strftime("%M").to_i),
					openings.mon_close.strftime("%H").to_i * 60 +
					openings.mon_close.strftime("%M").to_i, 24 *60 ], 
					css: "gray_section", type: "dhx_time_block" },
				{ days: 2, zones: [0,openings.tues_open.strftime("%H").to_i * 60 +
					(openings.tues_open.strftime("%M").to_i),
					openings.tues_close.strftime("%H").to_i * 60 +
					(openings.tues_close.strftime("%M").to_i), 24 *60 ], 
					css: "gray_section", type: "dhx_time_block" },
				{ days: 3, zones: [0,openings.wed_open.strftime("%H").to_i * 60 +
					(openings.wed_open.strftime("%M").to_i),
					openings.wed_close.strftime("%H").to_i * 60 +
					(openings.wed_close.strftime("%M").to_i), 24 *60 ], 
					css: "gray_section", type: "dhx_time_block" },
				{ days: 4, zones: [0,openings.thur_open.strftime("%H").to_i * 60 +
					(openings.thur_open.strftime("%M").to_i),
					openings.thur_close.strftime("%H").to_i * 60 +
					(openings.thur_close.strftime("%M").to_i), 24 *60 ], 
					css: "gray_section", type: "dhx_time_block" },
				{ days: 5, zones: [0,openings.fri_open.strftime("%H").to_i * 60 +
					(openings.fri_open.strftime("%M").to_i),
					openings.fri_close.strftime("%H").to_i * 60 +
					(openings.fri_close.strftime("%M").to_i), 24 *60 ], 
					css: "gray_section", type: "dhx_time_block" },
				{ days: 6, zones: [0,openings.sat_open.strftime("%H").to_i * 60 +
					(openings.sat_open.strftime("%M").to_i),
					openings.sat_close.strftime("%H").to_i * 60 +
					(openings.sat_close.strftime("%M").to_i), 24 *60 ], 
					css: "gray_section", type: "dhx_time_block" },
				{ days: 0, zones: [0,openings.sun_open.strftime("%H").to_i * 60 +
					(openings.sun_open.strftime("%M").to_i),
					openings.sun_close.strftime("%H").to_i * 60 +
					(openings.sun_close.strftime("%M").to_i), 24 *60 ], 
					css: "gray_section", type: "dhx_time_block" }
			]
		rescue NoMethodError => e
			puts "Error #{e}"
			[]
		ensure
			puts "Error #{e}"
			[]
		end		
	end

	def pick_show_teacher_view(id)		
		if teacher_signed_in?
			if is_mobile?
				render layout: 'application', action: 'teachers_views/mobile_show_teacher_to_user'
			elsif current_teacher.id.to_i == id.to_i && !current_teacher.is_teacher
				redirect_to '/'
			elsif current_teacher.id.to_i != id.to_i
				render layout: 'application', action: 'teachers_views/show_teacher_to_user'
			else 
				render layout: 'teacher_layout', action: 'teachers_views/show_teacher'			
			end
		elsif is_mobile?
			render layout: 'application', action: 'teachers_views/mobile_show_teacher_to_user'
		else
			render layout: 'application', action: 'teachers_views/show_teacher_to_user'
		end
	end

	def flash_class_name(name)
		case name
			when 'notice' then 'success'
			when 'alert' 	then 'danger'
			else name
		end
  end

  def star_helper(i)
  	html = ""
  	i.times do 
  		html << "<span style='color:#ffaa00;font-size:140%;'>★</span>"
  	end
  	return html.html_safe
  end

  def experience_delete_link(teacher, experience)
  	if !current_page?(show_teacher_path)
  		link_to 'Delete?', [teacher, experience], method: :delete, \
                    'data-confirm' => 'Are you sure', class: 'btn btn-danger btn-sm'
  		
  	end
  end

  def display_subjects(subjects, id) #create links to all teachers subjects
    subjects_list = subjects.map { |s| content_tag :u do 
    										link_to s.name, show_teacher_path(id: id, subject_id: s.id), class: 'teachers_subject_list'
    									end }
    subjects_list.join(',').html_safe
  end

  def get_auth_add_links(auth)
  	link_to "Add authentication", "/teachers/auth/#{auth}", id: "#{auth}_login_link"
  end

  def get_auth_delete_links(ident)
  	link_to("Delete authentictation",teacher_identity_path(current_teacher, ident.id), method: :delete, data: { confirm: 'Are you sure?' }).html_safe
  end

  def get_subjects_with_prices(subjects) #return only subjects with prices
    subjects.map { |s| s if !s.prices.empty? }.compact
  end

  def get_lowest_price(prices)
    number_to_currency(prices.min.price, unit: '€')
    # number_to_currency(subject.prices.min.price, unit: '€')
  end

  def get_subjects_list(subject) #the_one_modal get subject list
    ["#{subject.name}", subject.id]
  end

  def return_id_for_select
    :id
  end

  def return_text_for_select
    :name
  end

  def get_home_price(prices, subject) #t.prices.find(subject_id: 1)
    p "subject #{subject.id}"
    p = prices.select { |p| p.subject_id == subject.id && p.location_id == nil }.first
    p ? number_to_currency(p.price, unit: '€')  : "<span>Price not set</span>".html_safe
    
  end

  def get_location_name(teacher, price)
    l = teacher.locations.select { |l| l.id == price.location_id }.first
    if l 
      l.name
    else
      "Name not defined"
    end
    
  end

  def get_subject_name(teacher, price)
    p "price inspect #{price.inspect}"
    s = teacher.subjects.select { |s| s.id == price.subject_id }.first
    p "s inspect #{s.inspect}"
    if s 
      s.name
    else
      "No name defined"
    end
  end

  def get_select_text(p)
    # p "select text #{p.inspect}"
  	["#{p.no_of_lessons}x#{p.subject_name} lessons/#{p.duration} mins for #{ number_to_currency(p.price, unit: '€') }", p.id]
  end

end
