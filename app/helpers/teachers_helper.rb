module TeachersHelper
	def format_times(events)
		formatted_times = []
		events.each do |event| 
			formatted_times << { start: event.start_time.strftime('%Y-%m-%d %H:%M'), end: event.end_time.strftime('%Y-%m-%d %H:%M') }
		end
		formatted_times
	end
end
