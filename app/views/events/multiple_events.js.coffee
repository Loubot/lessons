<% if @event.instance_of? Array %>
  $('.payment_choice_error').remove().show 'slow'
  $('.modal-body').prepend("<div class='payment_choice_error'>").show('slow')
  $('.payment_choice_error').append '<%= escape_javascript(@event[0].to_s) %>'
  $('.payment_choice_error').append '</div>'
<% else %>
  $('.payment_choice_error').remove()
  $('#payment_choice_modal').modal 'hide'  #hide availability moda
  $('#payments_modal_for_users_multiple').modal 'show'
  $('#event_table_weeks_multiple').text "<%= @weeks.to_s %>"
  $('#event_table_start_time_multiple').text('<%= @event.start_time.to_formatted_s(:long) %>')
  $('#event_table_length_multiple').text("<%= total_time = '%.2f' % ((@event.end_time - @event.start_time) / 3600) %> hour(s)")
  $('#event_table_price_multiple').text "<%= @total_rate.to_s %>"
<% end %> 