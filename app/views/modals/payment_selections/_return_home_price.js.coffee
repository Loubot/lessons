
<% if @event.instance_of? Array %>
  $('.payment_choice_error').remove()
  $('#new_event').append """ <div class='payment_choice_error'>"""
  $('.payment_choice_error').append("<%= escape_javascript(@event[0].to_s) %>")
  $('.payment_choice_error').append("</div>")
<% else %>
  $('.payment_form_container').empty()
  $('.payment_form_container').empty()
  $('.display_teachers_location').empty()

  $('.payment_form_container').append """ 
      <h1>Price: <%= j(number_to_currency(@price.price, unit: '€')) %></h1><br>
    """



  $('.payment_form_container').append """
    <% if @teacher.has_payment_set? %> #only show buttons if teacher has payment set. 
      <div class="row">
        <div class="col-xs-6">
          <% if @teacher.paypal_email != "" %>
            <%= form_tag home_booking_paypal_path, class: 'home_booking_form', method: 'post' do %>
              <%= j(hidden_field_tag :teacher_id, @teacher.id) %>
              <%= j(hidden_field_tag :student_id, current_teacher.id) %>
              <%= j(hidden_field_tag :student_name, current_teacher.full_name) %>
              <%= j(hidden_field_tag :student_email, current_teacher.email) %>
              <%= j(hidden_field_tag :teacher_email, @teacher.email) %>
              <%= j(hidden_field_tag :teacher_name, @teacher.full_name) %>
              
              
              <%= j(hidden_field_tag :receiver_amount, @price.price) %>
              
              <%= j(hidden_field_tag :start_time, Time.now) %>
              <%= j(hidden_field_tag :end_time, Time.now + 5.minutes) %>
              <%= hidden_field_tag :paypal, '1' %>
              <%= hidden_field_tag :home_address, '', class: 'home_address' %>
              <%= hidden_field_tag :save_address, 'false', class: 'save_address' %>
              <%= hidden_field_tag :tracking_id, @cart.tracking_id %>
              <%= j(hidden_field_tag :price_id,  @price.id) %>
              <%= image_submit_tag 'https://www.paypalobjects.com/en_US/i/btn/x-click-but6.gif', class: 'img-responsive' %>

            <% end %>
          <% end %>
        </div> <%# end of col-xs-6 %>

        <div class="col-xs-6">
          <% if @teacher.stripe_access_token != "" %>
            <%= form_tag home_booking_stripe_path, class: 'home_booking_form', method: 'post' do %>
            <script src="https://checkout.stripe.com/checkout.js" class="stripe-button"
              data-key="<%= ENV['STRIPE_PUBLIC_KEY'] %>"
              data-description="Book your lesson"
              data-currency="eur"
              data-description="This is the description"
              data-imgage="<%= asset_url 'stripe.png' %>"
              ></script>
              <%= j(hidden_field_tag :teacher_id, @teacher.id) %>
              <%= j(hidden_field_tag :student_id, current_teacher.id) %>
              <%= j(hidden_field_tag :student_name, current_teacher.full_name) %>
              <%= j(hidden_field_tag :student_email, current_teacher.email) %>
              <%= j(hidden_field_tag :teacher_email, @teacher.email) %>
              <%= j(hidden_field_tag :teacher_name, @teacher.full_name) %>
              
              <%= j(hidden_field_tag :amount, @price.price) %>
                          
                     
              <%= j(hidden_field_tag :current_teacher, current_teacher.id) %> 
              <%= hidden_field_tag :start_time, DateTime.now %>           
              <%= hidden_field_tag :end_time, Time.now + 5.minutes %>   
              <%= hidden_field_tag :home_address, '', class: 'home_address' %>        
              <%= hidden_field_tag :save_address, 'false', class: 'save_address' %>
              <%= j(hidden_field_tag :price_id,  @price.id) %>
              <%= hidden_field_tag :tracking_id, @cart.tracking_id %>
            <% end %>

          <% end %>
        </div> <%# end of col-xs-6 %>
      </div> <%# end of row %>
    <% else %> <%# no payment method set %>
      <div class="row>
        <div class="col-xs-12>
          <h4>Book a lesson with <%= @cart.teacher_name %> <small>pay teacher in person</small></h4>
          <div class="table-responsive">
            <table class="table table-bordered">
              <tr>
                <td>Type:</td>
                <td><%= @cart.booking_type %></td>
              </tr>
              <tr>
                <td>Teacher name</td>
                <td><%= @cart.teacher_name %></td>
              </tr>
            </table>
          </div> <%# end of table-responsive %>
        </div> <%# end of col-mod-12 %>
      </div> <%# end of row %>
      <%= form_tag payless_booking_path(id: current_teacher.id), class: 'home_booking_form' do %>
        <%= submit_tag 'Book lesson', class: 'btn btn-lg btn-success center-block' %>
        <%= hidden_field_tag :home_address, '', class: 'home_address' %>
        <%= hidden_field_tag :save_address, 'false', class: 'save_address' %>
      <% end %>
    <% end %> 

    <div class="row">
      <div class="well">
          Enter your address. We can remember this for you if you want. 
        </div>
      <form class="form-horizontal">
        <div class="form-group">
          <label for="address" class="col-sm-2 control-label">Address</label>
          <div class="col-sm-10">
            <%= j(text_field_tag 'address', current_teacher.address, placeholder: 'Address',size: 40, id: 'home_booking_address') %>
            
          </div>
        </div>

        <div class="form-group">
          <div class="col-sm-offset-2 col-sm-10">
            <div class="checkbox">
              <label>
                <%= check_box_tag 'Remember', 'Remember address', current_teacher.address != '', id:'remember' %>Remember Address
              </label>
            </div>
          </div>
        </div>
        
      </form>

    </div> <%# end of row %>

                              """
<% end %> <%# end of if statement %>
