ready = ->
  if $('#scheduler_here').length > 0 
    scheduler.config.xml_date= "%Y-%m-%d %H:%i"
    scheduler.config.first_hour = 6
    scheduler.config.last_hour = 23
    scheduler.config.readonly = true
    #scheduler.config.limit_time_select = true;
    #scheduler.config.details_on_create = true;
    scheduler.locale.labels.timeline_tab = "Timeline"
    scheduler.locale.labels.unit_tab = "Unit"
    scheduler.locale.labels.section_custom = "Section"
    scheduler.init('scheduler_here')
    
    markTimespanWeek()


    events = gon.events
    scheduler.parse(events, 'json')
    
    
    scheduler.attachEvent "onViewChange", (new_mode, new_date) ->
      if new_mode is 'day' then markTimespanDay(new_date.getDay()) else markTimespanWeek()

    scheduler.attachEvent 'onAfterSchedulerResize', ->      
      state = scheduler.getState()

      if state.mode is 'day' then markTimespanDay(state.date.getDay()) else markTimespanWeek()
      
    
    events = checkEvents()

    # open = getOpen()
    # close = getClose()
  	
  	
    $("#date").AnyTime_picker
      format: "%Y-%m-%d"
    $('#start_time').AnyTime_picker
    	format: '%H:%i'
    $('#end_time').AnyTime_picker
    	format: '%H:%i'
  		
    # $('#button').click ->
    # 	alert $('#time_field').val()


checkEvents = () ->
  events = if gon.events == 'undefined' then [] else gon.events
  
  return events

checkOpenMins = ->
  (parseFloat(gon.openingTimes['openHour']) + parseFloat(gon.openingTimes['openMin'] / 60))  

checkCloseMins = ->
  (parseFloat(gon.openingTimes['closeHour']) + parseFloat(gon.openingTimes['closeMin'] / 60))


markTimespanDay = (day) ->
  switch day
    when 1 then scheduler.markTimespan gon.openingTimes[0]
    when 2 then scheduler.markTimespan gon.openingTimes[1]
    when 3 then scheduler.markTimespan gon.openingTimes[2]
    when 4 then scheduler.markTimespan gon.openingTimes[3]
    when 5 then scheduler.markTimespan gon.openingTimes[4]
    when 6 then scheduler.markTimespan gon.openingTimes[5]
    when 0 then scheduler.markTimespan gon.openingTimes[6]
    else return
  

markTimespanWeek = ->
  for time in gon.openingTimes
    scheduler.markTimespan time
    

$(document).ready(ready)
$(document).on('page:load', ready)