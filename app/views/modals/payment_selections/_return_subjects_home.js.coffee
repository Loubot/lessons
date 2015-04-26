$('.returned_locations_container').empty()
$('.returned_locations_container').append """
                                          <%= select 'subject', 'subject_id', @subjects.collect { |s| [s.name, s.id] }, { include_blank: true }, { class: 'form-control select_subject' } %>
                                          <%= hidden_field_tag 'location', 'home', class: 'location_value' %>
                                          <%= hidden_field_tag 'teacher', @teacher.id.to_s, class: 'teacher_id' %>
                                          """