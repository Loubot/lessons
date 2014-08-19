calendarDisplayTeacherReady = ->

	if $('.teachers_display_scheduler').length > 0
		scheduler.config.xml_date= "%m"
		scheduler.init('scheduler_here')

		

$(document).ready calendarDisplayTeacherReady
$(document).on('page:load', calendarDisplayTeacherReady)

