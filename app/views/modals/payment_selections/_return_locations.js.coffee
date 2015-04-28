# $('.returned_locations_container').empty()
$('.payment_form_container').empty()
$('.display_teachers_location').empty()
$('.display_teachers_location').append """
    <h3>Teachers location <small>See maps for more details</small></h3>
    <%= select 'teachers_locations', 'id', content_tag(:option,'select location...',:value=>"")+options_from_collection_for_select(@locations,'id','name'), {}, { class: 'form-control teachers_location_selection' } %>


  """