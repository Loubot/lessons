$(document).on 'page:change', ->
	$('#calendar').fullCalendar
			
			defaultView: 'agendaWeek'
			events: [
				title  : 'event3',
	      start  : '2014-06-24T6:30:00'
	      end 	 : '2014-06-24T8:30:00'
			]
	$('.datepicker').datepicker()
		dateFormat: 'yy-mm-dd'

