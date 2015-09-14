ready = ->
  if $('#grind_map_container').is(':visible')
    
    $.when(load_google_maps_api_grinds()).done ->


window.init_grinds_map = ->
  map = new google.maps.Map(document.getElementById('grind_map_container'), {
     center: {lat: gon.locations[0].latitude, lng: gon.locations[0].longitude},
     zoom: 8
   });
  
  for loc in gon.locations
    latLng =  
      lat: loc.latitude
      lng: loc.longitude

    marker = new (google.maps.Marker)(
        position: latLng
        map: map
        title: 'Grinds maps'
      )

    google.maps.event.addListener map, 'dragend', (e) ->

      grindCentral =  map.getCenter()
      console.log grindCentral.lat()

      $.ajax(
        method: 'get'
        dataType: 'json'
        url: 'grinds-search'
        data: 
          coords: 
            lat: grindCentral.lat()
            lon: grindCentral.lng() ).done (data) ->
        console.log data.latitude
        # map.setCenter(lat: data.latitude, lng: data.longitude)
        
    

load_google_maps_api_grinds = ->
  if !(google?) #if google maps already loaded   
  
    console.log 'loading'
    script = document.createElement("script")
    script.type = "text/javascript"
    script.src = "https://maps.googleapis.com/maps/api/js?key=AIzaSyBpOd04XM28WtAk1LcJyhlQzNW6P6OT2Q0&callback=init_grinds_map"
    document.body.appendChild script
  else
    console.log 'Google maps already loaded'



$(document).ready ready
$(document).on 'page:load', ready