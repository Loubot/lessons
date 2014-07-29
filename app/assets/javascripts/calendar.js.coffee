ready = ->
  if $('#scheduler_here').length > 0

    #scheduler config options
    scheduler.config.xml_date= "%Y-%m-%d %H:%i"
    scheduler.config.first_hour = 6
    scheduler.config.last_hour = 23
    scheduler.config.readonly = true
    #scheduler.config.limit_time_select = true;
    #scheduler.config.details_on_create = true;
    scheduler.locale.labels.timeline_tab = "Timeline"
    scheduler.locale.labels.unit_tab = "Unit"
    scheduler.locale.labels.section_custom = "Section"
    #// end of scheduler config options //

    # initialise scheduler
    scheduler.init('scheduler_here')
    #// end of initialise scheduler //

    # grey out time off
    markTimespanWeek()
    #// end of grey out time off //

    # get gon events
    events = gon.events
    # parse events into the scheduler
    scheduler.parse(events, 'json')
    #// end of get gon evetnts//
    
    # attach event to viewchange and mark time off after change
    scheduler.attachEvent "onViewChange", (new_mode, new_date) ->
      if new_mode is 'day' then markTimespanDay(new_date.getDay()) else markTimespanWeek()
    #// end of viewchange function//

    # attach event to onAfterSchedulerResize and mark time off when it's called
    scheduler.attachEvent 'onAfterSchedulerResize', ->      
      state = scheduler.getState()

      if state.mode is 'day' then markTimespanDay(state.date.getDay()) else markTimespanWeek()
    #// end of onAfterSchedulerResize //
      
    
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
# check if events is a valid object
checkEvents = () ->
  events = if gon.events == 'undefined' then [] else gon.events
  
  return events
#// end of events check//

# old function to parse time for scheduler
checkOpenMins = ->
  (parseFloat(gon.openingTimes['openHour']) + parseFloat(gon.openingTimes['openMin'] / 60))  

checkCloseMins = ->
  (parseFloat(gon.openingTimes['closeHour']) + parseFloat(gon.openingTimes['closeMin'] / 60))
#// end of scheduler time parser //

# mark timespan for correct day in day view only
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
#// end of mark timespan in dayview //

# mark time span in week view only
markTimespanWeek = ->
  for time in gon.openingTimes
    scheduler.markTimespan time
#// end of mark timespan in week view //   

$(document).ready(ready)
$(document).on('page:load', ready)