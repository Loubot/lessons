<% if @subjects.empty? %>
  if $('#teachers_search_input').val().length > 2
    $('#search_results').empty()
    $('#search_results').append("<%= j(link_to 'Subject not here?', create_new_subject_teacher_path(current_teacher.id), class: 'btn btn-info') %>")
<% else %>
  $('#search_results').empty()
  $('#search_results').append("<%= escape_javascript(render partial: 'partials/subjects', 
              collection: @subjects, as: :subject) %>")
<% end %>