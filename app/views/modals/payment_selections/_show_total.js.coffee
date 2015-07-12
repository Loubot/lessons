<% if @event.instance_of? Array %>
  $('.payment_choice_error').remove()
  $('#new_event').append """ <div class='payment_choice_error'>"""
  $('.payment_choice_error').append("<%= escape_javascript(@event[0].to_s) %>")
  $('.payment_choice_error').append("</div>")
<% else %>

  $('#the_one_modal').modal 'hide'
  $('#payment_no_location_modal').modal 'show'
  
  $('.teacher_name').text("<%= @cart.teacher_name %>")
  $('.booking_types').text("<%= @cart.booking_type %>")
  $('.teacher_name').text("<%= @cart.teacher_name %>")
<% end %>