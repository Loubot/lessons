$(document).on 'page:change', ->
	$('#calendar').fullCalendar
			
			defaultView: 'agendaWeek'
			events: [
				title  : 'event3',
	      start  : '2014-06-25T21:30:00'
	      end 	 : '2014-06-25T22:30:00'
			]
	AnyTime.picker "date_field",
    { format: "%W, %M %D in the Year %z %E", firstDOW: 1 } 
  $("#time_field").AnyTime_picker
    format: "%H:%i", labelTitle: "Hora",
      labelHour: "Hora", labelMinute: "Minuto" 

	