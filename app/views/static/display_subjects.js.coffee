
if window.markersArray?
  for marker in window.markersArray
    marker.setMap null

  window.markersArray = null
  window.markersArray = new Array()

  
# console.log "locations <%= pp @locations %>"
<% @locations.each do |loc| %>
latLng = new google.maps.LatLng "#{<%= loc.latitude.to_f %>}", "#{<%= loc.longitude.to_f %>}"
# console.log latLng
latLng = new google.maps.LatLng "#{<%= loc.latitude.to_f %>}", "#{<%= loc.longitude.to_f %>}"
# console.log latLng.lng()
marker = new google.maps.Marker(
  position: latLng
  map: grinds_map
  # title: loc.name
  )
# console.log marker
marker.setMap(grinds_map)
markersArray.push marker

<% end %> #end of google maps


$("#search_results_teachers_info").html ("""
  
  <% if @teachers.size > 0 %>
    <%= j( render partial: 'static/subjects_search', collection: @teachers, as: :teacher, locals: { subject: @subject }) %>
  <% else %>
    <%= render partial: 'partials/socials/no_results_share_buttons' %>
  <% end %>

""")