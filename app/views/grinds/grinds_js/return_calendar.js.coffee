$('#returned_calendar_container').html """
  <div class="row show_teacher_to_user">
    <div class="col-sm-12 col-xs-12 mob_no_padding">
      
      <div id="grinds_calendar" class="dhx_cal_container teachers_display_scheduler" >
        <div class="dhx_cal_navline" >
            <div class="dhx_cal_prev_button">&nbsp;</div>
            <div class="dhx_cal_next_button">&nbsp;</div>
            <div class="dhx_cal_date display_teachers_cal_date pull-left" id="display_teachers_cal_date"></div>
            
        </div> <!-- end of dhx_cal_navline -->
        <div class="dhx_cal_header"></div>
        <div class="dhx_cal_data"></div>       
      </div> <!-- end of scheduler_here -->   
    </div> <!-- end of col-sm-12 col-xs-12 mob_no_padding -->
  </div> <!-- end of row -->

"""

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

scheduler.init('returned_calendar_container')
scheduler.parse(@json_grinds ,'json')

