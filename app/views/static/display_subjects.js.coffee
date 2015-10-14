
if window.markersArray?

  clearMarkers()

window.markersArray = null
window.markersArray = new Array()


# console.log "locations <%= pp @locations.inspect %>"
<% @locations.each do |loc| %>
latLng = new google.maps.LatLng "#{<%= loc.latitude.to_f %>}", "#{<%= loc.longitude.to_f %>}"

marker = new google.maps.Marker(
  position: latLng
  map: search_map
  # title: loc.name
  )

marker.setMap(search_map)
markersArray.push marker

<% end %> #end of google maps



$("#search_results_teachers_info").html ("""

  
    <% if @teachers == [] %>
       <%= render partial: 'partials/socials/no_results_share_buttons' %>
     <% else %>
     <div class="apple_pagination">
       <div class="page_info">
         <%= page_entries_info @teachers %>
       </div><!--  end of page_info -->
       <%= will_paginate @teachers, :container => false %>
     </div> <!-- end of apple_pagination -->
     
     
       <%= render partial: 'static/subjects_search', collection: @teachers, as: :teacher %>
     
  
     <% end %>
  

""")