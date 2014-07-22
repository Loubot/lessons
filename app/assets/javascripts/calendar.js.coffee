$(document).on 'page:change', ->
  if $('#calendar').length > 0
    open = getOpen()
    close = getClose()
  	$('#calendar').fullCalendar
      handleWindowResize: true
      defaultView: 'agendaWeek'
      scrollTime:	'12:00:00	'
      minTime: open
      maxTime: close
      events: gon.events
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

getOpen = () ->
  return gon.openingTimes['open']

getClose = () ->
  return gon.openingTimes['close']
	