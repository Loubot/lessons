$('#student_email_modal').modal 'show'
$('#message_email').attr 'value', "<%= @student.email %>"
$('#message_email').attr 'text', "<%= @student.email %>"
$('#email').attr 'value', "<%= @student.email %>"
$('#email').attr 'text', "<%= @student.email %>"