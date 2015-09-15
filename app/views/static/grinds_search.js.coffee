# google map 
for marker in window.markersArray
    marker.setMap(null)

markersArray = null
markersArray = new Array()


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
    
    <%= j( render partial: 'grinds/grind', collection: @teachers, as: :teacher, locals: { subject: @subject }) %>

    """)