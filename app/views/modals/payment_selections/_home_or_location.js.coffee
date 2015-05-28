<% cache [@teacher, 'select_home_or_location'] do %>
$('.returned_locations_container').empty()
$('.display_teachers_location').empty()
$('.payment_form_container').empty()
$('.returned_locations_container').append """ 

	<%= form_tag get_subjects_path, remote: true, method: 'post', class:'get_subjects_form' do %>
    <%= select 'location', 'id', options_for_select([['teachers house or yours?....'],['Home lesson', 1], ['Teachers house', '2']]), {  }, { class: 'form-control select_home_or_location'} %>
    <input type="hidden" name="location[teacher_id]" value="<%= @teacher.id %>">
    
    <input type="hidden" name="location[subject_id]" value="" class="subject_id">
  <% end %> <%# end of form %>                                
  																				"""

<% end %>