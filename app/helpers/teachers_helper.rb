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
			open_close = { openHour: open.strftime("%H"),openMin: open.strftime("%M"),
			 closeHour: close.strftime("%H"), closeMin: close.strftime("%M") }
		else
			open_close = { openHour: '7', openMin: '00', closeHour: '17', closeMin: '30' }
		end
		open_close
	end
end
