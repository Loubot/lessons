module TeachersHelper
	def format_times(events) #create array of events with times formatted correctly
		formatted_times = []
		events.each do |event|
			formatted_times << {id: event.id, text: event.title, textColor: 'white',
										 start_date: event.start_time.strftime('%Y-%m-%d %H:%M'), 
										end_date: event.end_time.strftime('%Y-%m-%d %H:%M'), color:'#0E64A0',
										teacher_id: event.teacher_id, description: event.teacher.first_name
										#url: "/teachers/#{current_teacher.id}/events/#{event.id}/edit"
										 }
		end
		formatted_times
	end

	def public_format_times(events) #return array of formatted times with name removed for privacy
		formatted_times = []
		events.each do |event|
			#event.time_off == '1' ? eventColor = '#e6e6e6' : eventColor = '#d9534f'
			formatted_times << {id: event.id, text: 'Booking', textColor: 'white',
										 start_date: event.start_time.strftime('%Y-%m-%d %H:%M'), 
										end_date: event.end_time.strftime('%Y-%m-%d %H:%M'), color:'#0E64A0',
										teacher_id: event.teacher_id
										#url: "/teachers/#{current_teacher.id}/events/#{event.id}/edit"
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
			if current_teacher.id.to_i == id.to_i && !current_teacher.is_teacher
				redirect_to '/'
			elsif current_teacher.id.to_i != id.to_i
				render layout: 'application', action: 'show_teacher_to_user'
			else 
				render layout: 'teacher_layout', action: 'show_teacher'			
			end
		else
			render layout: 'application', action: 'show_teacher_to_user'
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

  def experience_delete_link(experience)
  	if !current_page?(show_teacher_path)
  		(link_to 'Delete', experience_path(experience.id), class: 'btn btn-danger btn-sm', method: 'DELETE', data: { confirm: 'Are you sure' }).html_safe
  	end
  end

  def display_subjects(subjects, id) #create links to all teachers subjects
    subjects_list = subjects.map { |s| content_tag :u do 
    										link_to s.name, show_teacher_path(id: id, subject_id: s.id), class: 'teachers_subject_list'
    									end }
    subjects_list.join(',').html_safe
  end

  def get_auth_add_links(auth)
  	link_to("Add authentication", "/teachers/auth/#{auth}").html_safe
  end

  def get_auth_delete_links(ident)
  	link_to("Delete authentictation",teacher_identity_path(current_teacher, ident.id), method: :delete, data: { confirm: 'Are you sure?' }).html_safe
  end

  def check_if_price(prices, location)
    prices.any? { |p| p.location_id == location && p.subject_id == subject.id }
  end

  def get_price_or_message(prices, location, subject, teacher)
    p =  prices.find_by(location_id: location, subject_id: subject, teacher_id: teacher)
    p ? number_to_currency(p.price, unit: '€') : "Teacher does not teach this subject here"
  end

end
