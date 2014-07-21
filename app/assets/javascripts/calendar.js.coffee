$(document).on 'page:change', ->
  if $('#calendar').length > 0
  	$('#calendar').fullCalendar
      handleWindowResize: true
      defaultView: 'agendaWeek'
      scrollTime:	'12:00:00	'
      minTime: '07:00'
      events: gon.events
      eventColor: 'red'
      allDaySlot: false
      selectable: true
      selectHelper: true
      header: right:  'today prev,next', center: 'month,agendaWeek,agendaDay'
      select: (start, end, jsEvent, view) ->
        alert jsEvent
        return

    $('#calendar').fullcalendar 
  	
    $("#date").AnyTime_picker
      format: "%Y-%m-%d"
    $('#start_time').AnyTime_picker
    	format: '%H:%i'
    $('#end_time').AnyTime_picker
    	format: '%H:%i'
  		
    $('#button').click ->
    	alert $('#time_field').val()
	