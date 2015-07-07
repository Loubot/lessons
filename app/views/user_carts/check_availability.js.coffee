$('#the_one_modal').modal 'hide'
$('#booking_modal').modal 'show'


$('.booking_form_container').html """

    <%= j(render partial: 'partials/show_teacher/booking_forms/no_payment_form') %>


"""