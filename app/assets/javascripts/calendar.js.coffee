$(document).on 'page:change', ->
  if $('#calendar').length > 0
    events = checkEvents()

    open = getOpen()
    close = getClose()
  	$('#calendar').fullCalendar
      handleWindowResize: true
      defaultView: 'agendaWeek'
      scrollTime:	'12:00:00	'
      minTime: open
      maxTime: close
      events: events
      allDaySlot: false
      selectable: true
      selectHelper: true
      header: right:  'today prev,next', center: 'month,agendaWeek,agendaDay'
      select: (start, end, jsEvent, view) ->
        alert jsEvent
      eventRender: (event, element) ->
        alert element[0]
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


checkEvents = () ->
  events = if gon.events == 'undefined' then [] else gon.events
  
  return gon.events

getOpen = () ->
  return gon.openingTimes['open']

getClose = () ->
  return gon.openingTimes['close']
	