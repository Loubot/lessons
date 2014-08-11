ready = ->
  if $('#scheduler_here').length > 0

    #scheduler config options
    scheduler.config.xml_date= "%Y-%m-%d %H:%i"
    scheduler.config.first_hour = 6
    scheduler.config.last_hour = 23
    scheduler.config.readonly = false
    scheduler.config.time_step = 30
    #scheduler.config.limit_time_select = true;
    #scheduler.config.details_on_create = true;
    scheduler.config.drag_create = false
    scheduler.config.drag_resize= false
    scheduler.locale.labels.timeline_tab = "Timeline"
    scheduler.locale.labels.unit_tab = "Unit"
    scheduler.locale.labels.section_custom = "Section"
    scheduler.config.wide_form = false
    scheduler.config.dblclick_create = false
    format = scheduler.date.date_to_str("%d-%m-%Y %H:%i")
    
    
    scheduler.config.details_on_create= true;
    scheduler.config.details_on_dblclick= true;
    
    #// end of scheduler config options //

    # get gon events
    events = checkEvents()

    # initialise scheduler
    scheduler.init('scheduler_here')
    #// end of initialise scheduler //

    # onclick will disable edit buttons
    scheduler.attachEvent 'onClick',  -> 

    #// end of onclick

    #// lightbox delete button handler
    scheduler.attachEvent "onConfirmedBeforeEventDelete", (id, e) ->
      console.log JSON.stringify e
      $.ajax
        url: "/teachers/#{e.teacher_id}/events/#{e.id}"
        type: 'DELETE'
        success: location.reload()
        error: (error) ->
          console.log error      
    #//end of lightbox delete handler

    #// start event save handler
    scheduler.attachEvent "onEventSave", (id,ev,is_new) ->
      #console.log Date.parse(ev.start_date)
      $.ajax
        url: "/teachers/#{gon.events[0].teacher_id}/events/#{id}"
        data: { event: { title: ev.title, start_time: (Date.parse(ev.start_date))/1000, end_time: (Date.parse(ev.end_date)) /1000,id: ev.id }}
        type: 'put'
        success: (json) ->
          #scheduler.parse json, 'json'
          console.log JSON.stringify json
          dhtmlx.message
            text:"Event updated successfully"
            expire:1000
            type: 'myCss'
          switch scheduler.getState()
            when 'day' then markTimespanDay(state.date.getDay())
            when 'week' then markTimespanWeek(state.date.getDay())
            else return
        error: (error) ->
          location.reload()
    #// end of event save hanlder

    # grey out time off
    markTimespanWeek()
    #// end of grey out time off //    

    # parse events into the scheduler
    scheduler.parse(events, 'json')
    #// end of get gon events// 

    # scheduler.templates.tooltip_text = (start, end, event) ->
    #   "<b>Event:</b> " + event.text + "<br/><b>Start date:</b> " + format(start) + "<br/><b>End date:</b> " + format(end)
    
    # attach event to viewchange and mark time off after change
    scheduler.attachEvent "onViewChange", (new_mode, new_date) ->
      switch new_mode
        when 'day' then markTimespanDay(new_date.getDay())
        when 'week' then markTimespanWeek(new_date.getDay())
        else return
      
    #// end of viewchange function//

    


    # attach event to onAfterSchedulerResize and mark time off when it's called
    scheduler.attachEvent 'onAfterSchedulerResize', ->      
      switch scheduler.getState()
        when 'day' then markTimespanDay(state.date.getDay())
        when 'week' then markTimespanWeek(state.date.getDay())
        else return

      #if state.mode is 'day' then markTimespanDay(state.date.getDay()) else markTimespanWeek()
    #// end of onAfterSchedulerResize //
      
    
    
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