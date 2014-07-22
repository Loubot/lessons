module TeachersHelper
	def format_times(events)
		formatted_times = []
		events.each do |event|
			event.time_off == '1' ? eventColor = '#e6e6e6' : eventColor = '#d9534f'
			formatted_times << {title: event.title, start: event.start_time.strftime('%Y-%m-%d %H:%M'), 
										end: event.end_time.strftime('%Y-%m-%d %H:%M'),
										url: "/teachers/#{current_teacher.id}/events/#{event.id}/edit",
										color: eventColor, textColor: 'black' }
		end
		formatted_times
	end

	def open_close_times(open, close)
		if (open != nil && close != nil)
			open_close = { open: open.strftime("%H:%M"), close: close.strftime("%H:%M") }
		else
			open_close = { open: '07:00', close: '17:00'}
		end
		open_close
	end
end
