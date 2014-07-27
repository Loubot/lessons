ready = ->
  if $('#scheduler_here').length > 0 
    scheduler.config.xml_date= "%Y-%m-%d %H:%i"
    scheduler.config.first_hour = 6
    scheduler.config.last_hour = 20
    #scheduler.config.limit_time_select = true;
    #scheduler.config.details_on_create = true;
    scheduler.locale.labels.timeline_tab = "Timeline"
    scheduler.locale.labels.unit_tab = "Unit"
    scheduler.locale.labels.section_custom = "Section"
    scheduler.init('scheduler_here')
    scheduler.markTimespan
      days: 0
      zones: [        
        (parseFloat(gon.openingTimes['openHour']) + parseFloat(checkOpenMins())) * 60
        (parseFloat(gon.openingTimes['closeHour']) + parseFloat(checkCloseMins())) * 60        
      ]
      invert_zones: true
      css: "gray_section"
      type: "dhx_time_block" #the hardcoded valuee
    scheduler.attachEvent "onViewChange", (new_mode, new_date) ->
      date = new Date(new_date)
      if (date.getDay() is 0) or (date.getDay() is 3)
        scheduler.markTimespan
          days: 0
          zones: [
            4 * 60
            8 * 60
            12 * 60
            15 * 60
          ]
          invert_zones: false
          css: "gray_section"
          type: "dhx_time_block" #the hardcoded valuee
          
    events = checkEvents()

    open = getOpen()
    close = getClose()
  	
  	
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

getOpen = () ->
  return gon.openingTimes['open']

getClose = () ->
  return gon.openingTimes['close']

checkOpenMins = ->
  openMins = gon.openingTimes['openMin']
  return mins = if openMins != '00' then (openMins / 60) else 0

checkCloseMins = ->
  closeMins = gon.openingTimes['closeMin']
  return mins = if closeMins != '00' then (closeMins / 60) else 0

$(document).ready(ready)
$(document).on('page:load', ready)