$(document).ready ->

  if $('#scheduler_here').length > 0 
    scheduler.config.xml_date= "%Y-%m-%d %H:%i";
    scheduler.config.first_hour = 2;
    scheduler.config.last_hour = 20;
    #scheduler.config.limit_time_select = true;
    #scheduler.config.details_on_create = true;
    scheduler.locale.labels.timeline_tab = "Timeline";
    scheduler.locale.labels.unit_tab = "Unit";
    scheduler.locale.labels.section_custom = "Section";
    scheduler.init('scheduler_here');
    scheduler.attachEvent "onViewChange", (new_mode, new_date) ->
      date = new Date(new_date)
      alert date.getDay()
      if (date.getDay() is 2) or (date.getDay() is 3)
        scheduler.markTimespan
          days: 2
          zones: [
            4 * 60
            8 * 60
            12 * 60
            15 * 60
          ]
          invert_zones: true
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
  		
    $('#button').click ->
    	alert $('#time_field').val()


checkEvents = () ->
  events = if gon.events == 'undefined' then [] else gon.events
  
  return gon.events

getOpen = () ->
  return gon.openingTimes['open']

getClose = () ->
  return gon.openingTimes['close']
	