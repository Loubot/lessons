#function to mark teachers opening times
markTime = ->
  for time in gon.openingTimes
    scheduler.markTimespan time
#end of function to mark teachers openingTimes 

calendarDisplayTeacherReady = ->
  if $('.teachers_display_scheduler').length > 0
    scheduler.config.xml_date= "%Y-%m-%d %H:%i"
    scheduler.config.first_hour = 6
    scheduler.config.last_hour = 23
    scheduler.config.readonly = true
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
    scheduler.config.details_on_create= false
    scheduler.config.details_on_dblclick= false

    scheduler.init('scheduler_here')
    scheduler.parse(gon.events ,'json')
		#///////////mark teachers opening times
    markTime()

    scheduler.attachEvent 'onAfterSchedulerResize', -> 
      markTime()		

    scheduler.attachEvent "onViewChange", (new_mode, new_date) ->
      markTime()
		# end of mark teachers opening times
		


		

$(document).ready calendarDisplayTeacherReady()
$(document).on('page:load', calendarDisplayTeacherReady())
