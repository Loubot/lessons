module TeachersHelper
	def format_times(events)
		#start_date: "2014-07-27 09:00", end_date: "2014-07-27 12:00",
		formatted_times = []
		events.each do |event|
			#event.time_off == '1' ? eventColor = '#e6e6e6' : eventColor = '#d9534f'
			formatted_times << {id: event.id, text: event.title,
										 start_date: event.start_time.strftime('%Y-%m-%d %H:%M'), 
										end_date: event.end_time.strftime('%Y-%m-%d %H:%M'), color:'#0E64A0' 
										#url: "/teachers/#{current_teacher.id}/events/#{event.id}/edit"
										 }
		end
		formatted_times
	end

	def open_close_times(openings)
		{ days: 1, zones: [0,openings.mon_open.strftime("%H").to_i * 60,
			openings.mon_close.strftime("%H").to_i * 60, 24 *60 ], 
			css: "gray_section", type: "dhx_time_block" }
	end
end
