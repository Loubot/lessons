<% cache([@teacher, current_teacher,'return_home_price']) do %>
$('.payment_form_container').empty()
$('.payment_form_container').empty()
$('.display_teachers_location').empty()
$('.returned_locations_container').empty()
<% if defined? @deleteReturnedLocations %>
$('.returned_locations_container').empty()
$('.payment_form_container').append """ 
    <h1>Price: <%= j(number_to_currency(@price.price, unit: '€')) %><small> only home lesson available</small></h1><br>
  """
<% else %>
$('.payment_form_container').append """ 
    <h4>Price: <%= j(number_to_currency(@price.price, unit: '€')) %></h4>
  """
<% end %>


$('.payment_form_container').append """
            <h2>Check availability</h2>
            <div class="col-xs-12">
              <%= form_for(@event, url: events_check_home_event_path, html: { class: 'form-horizontal' }, method: 'post') do |f| %>
                <div class="row">
                  <div class="col-xs-6 form-group">
                    
                    <div>
                      <label for="date" class="control-label">Date:</label>
                      <input name="event[date]" type="text" id='home_lesson_datepicker' placeholder='Click to select date' class="1payment_choice_date_picker" >
                    </div>
                  </div> <!-- end of form-group -->
                  <div class="col-xs-6">
                    <div class='form-group'>
                      <%= label_tag 'start_time', 'Start-time:', class: 'col-sm-2 control-label' %>
                      <div class="col-sm-10">
                        <%= f.time_select :start_time,
                              {
                                :combined => true,
                                :default => Time.now.change(:hour => 11, :min => 30),
                                :minute_interval => 30,
                                :time_separator => "",
                                :start_hour => 10,
                                :start_minute => 30,
                                :end_hour => 14,
                                :end_minute => 30
                              },
                              
                              { class: 'form-control' }
                            %>
                      </div> <!-- end of col-sm-8 -->
                    </div> <!-- end of form-group -->
                  </div> <!-- end of col-xs-6 -->

                  <div class="col-xs-6">
                    <div class="form-group">
                      <%= label_tag 'end_time', 'End-time:', class: 'col-sm-2 control-label' %>
                      <div class="col-sm-10">
                        <%= f.time_select :end_time,
                                      {
                                        :combined => true,
                                        :default => Time.now.change(:hour => 12, :min => 30),
                                        :minute_interval => 30,
                                        :time_separator => "",
                                        :start_hour => 10,
                                        :start_minute => 30,
                                        :end_hour => 14,
                                        :end_minute => 30
                                      },
                                      { class: 'form-control'}
                                    %>
                      </div> <!-- end of col-sm-10 -->
                    </div> <!-- end of form-group -->
                  </div> <!-- end of col-xs-6 -->

                </div> <%# end of row %>
                <%= j(hidden_field :event, :teacher_id, value: @teacher.id) %>

                <%= f.submit 'hello' %>
              <% end %> <%# end of form %>
            </div> <%# end of col-xs-12 %>
  """




<% end %>


AnyTime.noPicker 'location_only_datepicker' #activate anytime datepicker
$("#home_lesson_datepicker").AnyTime_picker
  format: "%Y-%m-%d"
  placement: 'inline'
  hideInput: true
