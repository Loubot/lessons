# google map 
for marker in window.markersArray
    marker.setMap(null)

markersArray = null
markersArray = new Array()


console.log "length <% @teachers.length %>"
<% @locations.each do |loc| %>

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

<% end %>
# end of google map


$("#display_grinds_teachers").html (""" 
    
    <% if @teachers.size > 0 %>
      <%= j( render partial: 'grinds/grind', collection: @teachers, as: :teacher, locals: { subject: @subject }) %>
    <% else %>
      <%= render partial: 'partials/socials/no_results_share_buttons' %>
    <% end %>

    """)