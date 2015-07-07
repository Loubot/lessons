<% if @selection == '1' %>
$('.check_availabilty_form_container').html """
    <%= j(render partial: 'partials/show_teacher/user_cart_forms/home_only') %>
  """

<% else %>
$('.check_availabilty_form_container').html """
    <%= j(render partial: 'partials/show_teacher/user_cart_forms/location_only') %>
  """


<% end %>



AnyTime.noPicker 'home_lesson_datepicker' #activate anytime datepicker
$("#home_lesson_datepicker").AnyTime_picker
  format: "%Y-%m-%d"
  placement: 'inline'
  hideInput: true
