# google map 

if window.markersArray?
  console.log "yep yep"
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
# end of google map

$("#grind_display_search_results").html (""" 
    
    <div id="search_results_teachers_info">
      <% if @teachers == [] %>
        <%= render partial: 'partials/socials/no_results_share_buttons' %>
      <% else %>
      <div class="apple_pagination">
        <div class="page_info">
          <%= page_entries_info @teachers %>
        </div><!--  end of page_info -->
        <%= will_paginate @teachers, :container => false %>
      </div> <!-- end of apple_pagination -->
      
      
        <%= render partial: 'grinds/grind', collection: @teachers, as: :teacher, locals: { subject: @subject } %>
      
    
      <% end %>
    </div> <!-- end of search_results_teachers_info -->

    """)