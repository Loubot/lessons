$(document).on 'page:change', ->
	$('#calendar').fullCalendar
			
			defaultView: 'agendaWeek'
			scrollTime:	'12:00:00	'
			events: [
				title  : 'event3',
	      start  : '2014-06-25T21:30:00'
	      end 	 : '2014-06-25T22:30:00'
			]
	
  $("#date").AnyTime_picker
    format: "%Y-%m-%d"
  $('#start_time').AnyTime_picker
  	format: '%H:%i'
  $('#end_time').AnyTime_picker
  	format: '%H:%i'
		
  $('#button').click ->
  	alert $('#time_field').val()
	