<% if @subjects.empty? %>
  if $('#teachers_search_input').val().length > 3
    $('#search_results').empty()
    $('#search_results').append("<a class='btn btn-info no_subject_found'>Subject not here?<a>")
<% else %>
  $('#search_results').empty()
  $('#search_results').append("<%= escape_javascript(render partial: 'partials/subjects', 
              collection: @subjects, as: :subject) %>")
<% end %>