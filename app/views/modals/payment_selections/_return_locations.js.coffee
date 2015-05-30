# $('.returned_locations_container').empty()
$('.payment_form_container').empty()
$('.display_teachers_location').empty()
$('.display_teachers_location').append """
	<%= form_tag get_locations_price_path, remote: true, method: 'post', class: 'get_locations_price_form' do %>
    <h3>Teachers location <small>See maps for more details</small></h3>
    <%= j(select 'teachers_locations', 'location_id', content_tag(:option,'select location...',:value=>"")+options_from_collection_for_select(@locations,'id','name'), {}, { class: 'form-control teachers_location_selection' }) %>
    <input type="hidden" name="teachers_locations[teacher_id]" value="<%= @teacher.id %>">
    <input type="hidden" name="teachers_locations[subject_id]" value="" class="teachers_locations_subject">

  <% end %> <%# end of form %>
  """