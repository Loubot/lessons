module TeachersHelper
	def format_times(events)
		#start_date: "2014-07-27 09:00", end_date: "2014-07-27 12:00",
		formatted_times = []
		events.each do |event|
			#event.time_off == '1' ? eventColor = '#e6e6e6' : eventColor = '#d9534f'
			formatted_times << {id: event.id, text: event.title, textColor: 'white',
										 start_date: event.start_time.strftime('%Y-%m-%d %H:%M'), 
										end_date: event.end_time.strftime('%Y-%m-%d %H:%M'), color:'#0E64A0',
										teacher_id: event.teacher_id
										#url: "/teachers/#{current_teacher.id}/events/#{event.id}/edit"
										 }
		end
		formatted_times
	end

	def public_format_times(events)
		#start_date: "2014-07-27 09:00", end_date: "2014-07-27 12:00",
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

	def open_close_times(openings)
		begin
			[
				{ days: 1, zones: [0,openings.mon_open.strftime("%H").to_i * 60,
					openings.mon_close.strftime("%H").to_i * 60, 24 *60 ], 
					css: "gray_section", type: "dhx_time_block" },
				{ days: 2, zones: [0,openings.tues_open.strftime("%H").to_i * 60,
					openings.tues_close.strftime("%H").to_i * 60, 24 *60 ], 
					css: "gray_section", type: "dhx_time_block" },
				{ days: 3, zones: [0,openings.wed_open.strftime("%H").to_i * 60,
					openings.wed_close.strftime("%H").to_i * 60, 24 *60 ], 
					css: "gray_section", type: "dhx_time_block" },
				{ days: 4, zones: [0,openings.thur_open.strftime("%H").to_i * 60,
					openings.thur_close.strftime("%H").to_i * 60, 24 *60 ], 
					css: "gray_section", type: "dhx_time_block" },
				{ days: 5, zones: [0,openings.fri_open.strftime("%H").to_i * 60,
					openings.fri_close.strftime("%H").to_i * 60, 24 *60 ], 
					css: "gray_section", type: "dhx_time_block" },
				{ days: 6, zones: [0,openings.sat_open.strftime("%H").to_i * 60,
					openings.sat_close.strftime("%H").to_i * 60, 24 *60 ], 
					css: "gray_section", type: "dhx_time_block" },
				{ days: 0, zones: [0,openings.sun_open.strftime("%H").to_i * 60,
					openings.sun_close.strftime("%H").to_i * 60, 24 *60 ], 
					css: "gray_section", type: "dhx_time_block" }
			]
		rescue NoMethodError
			[]
		ensure
			[]
		end		
	end

	def pick_show_teacher_view
		if current_teacher.is_teacher == true
			puts "aaaaaaaaaaaaaaaaa"
			render layout: 'teacher_layout', action: 'show_teacher'	

		else
			puts "bbbbbbbbbbbb"
			render layout: 'application', action: 'show_teacher_to_user'
		end
	end
end
