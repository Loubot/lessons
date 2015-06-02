<% cache([@teacher, current_teacher,@price,'return_home_price_checker']) do %>
$('.payment_form_container').empty()
$('.payment_form_container').empty()
$('.display_teachers_location').empty()
# $('.returned_locations_container').empty()

$('.payment_form_container').append """ 
    <h4>Price: <%= j(number_to_currency(@price.price, unit: '€')) %><small> At your house</small></h4>
  """


$('.payment_form_container').append """
            <h2>Check availability</h2>
            <div class="col-xs-12">
              <%= form_for(@event, url: teachers_check_home_event_path, html: { class: 'form-horizontal' }, method: 'post', remote: true) do |f| %>
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
                <input type="hidden" name="id" id="id" value="<%= @teacher.id %>">
                <%= j(hidden_field :event, :teacher_id, value: @teacher.id) %>
                <%= j(hidden_field :event, :teacher_email, value: @teacher.email) %>
                <%= j(hidden_field :event, :student_email, value: current_teacher.email) %>
                <%= j(hidden_field :event, :student_id, value: current_teacher.id) %>
                <%= j(hidden_field :event, :teacher_name, value: @teacher.full_name) %>
                <%= j(hidden_field :event, :student_name, value: current_teacher.full_name) %>
                <%# j(hidden_field :event, :rate, value: @price.price) %>
                <%= j(hidden_field_tag :price_id,  @price.id) %>


                <%= f.submit 'Check availability', class: 'btn btn-success' %>
              <% end %> <%# end of form %>
            </div> <%# end of col-xs-12 %>
  """




<% end %>


AnyTime.noPicker 'home_lesson_datepicker' #activate anytime datepicker
$("#home_lesson_datepicker").AnyTime_picker
  format: "%Y-%m-%d"
  placement: 'inline'
  hideInput: true
