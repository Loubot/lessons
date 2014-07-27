ready = ->
  if $('#scheduler_here').length > 0 
    scheduler.config.xml_date= "%Y-%m-%d %H:%i"
    scheduler.config.first_hour = 6
    scheduler.config.last_hour = 20
    scheduler.config.readonly = true;
    #scheduler.config.limit_time_select = true;
    #scheduler.config.details_on_create = true;
    scheduler.locale.labels.timeline_tab = "Timeline"
    scheduler.locale.labels.unit_tab = "Unit"
    scheduler.locale.labels.section_custom = "Section"
    scheduler.init('scheduler_here')
    scheduler.markTimespan
      days: 0
      zones: [        
        checkOpenMins() * 60
        checkCloseMins() * 60        
      ]
      invert_zones: true
      css: "gray_section"
      type: "dhx_time_block" #the hardcoded valuee
    events = gon.events
    scheduler.parse(events, 'json')
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

$(document).ready(ready)
$(document).on('page:load', ready)