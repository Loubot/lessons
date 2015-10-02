$('#returned_calendar_container').html "<%= j(render '_calendar.html.erb') %>"
# console.log "<%= @json_grinds %>"

# console.log "gon #{gon.grinds}"

# grinds = '<%= j @json_grinds %>'
# console.log grinds[0]
#   # [{"id":1,"text":"Louis Angelini\u003cbr\u003ePayment: active","textColor":"white","start_date":"2015-10-01 11:30","end_date":"2015-10-01 12:30","color":"#0E64A0","teacher_id":1,"description":"Louis","status":"active"}]


# scheduler.config.xml_date= "%Y-%m-%d %H:%i"
# scheduler.config.first_hour = 6
# scheduler.config.last_hour = 23
# scheduler.config.readonly = true
# scheduler.config.time_step = 30
# #scheduler.config.limit_time_select = true;
# #scheduler.config.details_on_create = true;
# scheduler.config.drag_create = false
# scheduler.config.drag_resize= false
# scheduler.locale.labels.timeline_tab = "Timeline"
# scheduler.locale.labels.unit_tab = "Unit"
# scheduler.locale.labels.section_custom = "Section"
# scheduler.config.wide_form = false
# # scheduler.config.dblclick_create = false
# format = scheduler.date.date_to_str("%d-%m-%Y %H:%i")
# scheduler.config.details_on_create= false
# scheduler.config.details_on_dblclick= false

# # console.log JSON.stringify events

# scheduler.init('returned_calendar_container')
# scheduler.parse(grinds,'json')

