$('.payment_form_container').empty()


$('.payment_form_container').append """
  <div class="col-xs-6">
    <% if @teacher.paypal_email != "" %>
      <%= form_tag home_booking_paypal_path, class: 'home_booking_form', method: 'post' do %>
        <%= hidden_field_tag :teacher_id, @teacher.id %>
        <%= hidden_field_tag :student_id, current_teacher.id %>
        <%= hidden_field_tag :student_name, current_teacher.full_name %>
        <%= hidden_field_tag :student_email, current_teacher.email %>
        <%= hidden_field_tag :teacher_email, @teacher.email %>
        
        
        <%= hidden_field_tag :receiver_amount, @prices.price %>
        
        <%= hidden_field_tag :start_time, Time.now %>
        <%= hidden_field_tag :end_time, Time.now + 5.minutes %>
        <%= hidden_field_tag :paypal, '1' %>
        <%= hidden_field_tag :home_address, '', class: 'home_address' %>
        <%= hidden_field_tag :save_address, 'false', class: 'save_address' %>
        <%# hidden_field_tag :tracking_id, '', class: 'tracking_id' %>
        <%= image_submit_tag 'https://www.paypalobjects.com/en_US/i/btn/x-click-but6.gif', class: 'img-responsive' %>





      <% end %>
    <% end %>
  </div> <%# end of col-xs-6 %>

  <div class="col-xs-6">
    <% if @teacher.stripe_access_token != "" %>
      <%= form_tag home_booking_stripe_path, class: 'home_booking_form', method: 'post' do %>
      <script src="https://checkout.stripe.com/checkout.js" class="stripe-button"
        data-key="pk_test_bedFzS7vnmzthkrQolmUjXNn"
        data-description="Book your lesson"
        data-currency="eur"
        data-description="This is the description"
        data-imgage="<%= asset_url 'stripe.png' %>"
        ></script>
        <%= hidden_field_tag :teacher_id, @teacher.id %>
        <%= hidden_field_tag :student_id, current_teacher.id %>
        <%= hidden_field_tag :student_name, current_teacher.full_name %>
        <%= hidden_field_tag :student_email, current_teacher.email %>
        <%= hidden_field_tag :teacher_email, @teacher.email %>
        
        <%= hidden_field_tag :amount, @prices.price %>
                    
               
        <%= hidden_field_tag :current_teacher, current_teacher.id %> 
        <%= hidden_field_tag :start_time, Time.now %>           
        <%= hidden_field_tag :end_time, Time.now + 5.minutes %>   
        <%= hidden_field_tag :home_address, '', class: 'home_address' %>        
        <%= hidden_field_tag :save_address, 'false', class: 'save_address' %>
      <% end %>

    <% end %>
  </div> <%# end of col-xs-6 %>
                            """