$(document).on 'page:change', ->
	$('#calendar').fullCalendar
			
			defaultView: 'agendaWeek'
			scrollTime:	'12:00:00	'
			events: gon.events
	
  $("#date").AnyTime_picker
    format: "%Y-%m-%d"
  $('#start_time').AnyTime_picker
  	format: '%H:%i'
  $('#end_time').AnyTime_picker
  	format: '%H:%i'
		
  $('#button').click ->
  	alert $('#time_field').val()
	