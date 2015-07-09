


<% if @event.valid? %>

<% if @teacher.has_payment_set? %>
$('.booking_form_container').html """ <%= j(render partial: 'partials/show_teacher/booking_forms/payment_form') %> """
<% else %>
$('.booking_form_container').html """ <%= j(render partial: 'partials/show_teacher/booking_forms/no_payment_form') %> """
<% end %>


$('#the_one_modal').modal 'hide'
$('#booking_modal').modal 'show'
<% else %>

$('.errors_container').html """ <p class="payment_choice_error"> 
              <%= @event.errors.full_messages[0].to_s %></p> """

<% end %>


