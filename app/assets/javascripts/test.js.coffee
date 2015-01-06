window.start_address_search = (id = "") ->
  geocoder = new google.maps.Geocoder()
  geocoder.geocode address: $("#address#{id}").val(), (results, status) ->
    if status is google.maps.GeocoderStatus.OK
      # alert JSON.stringify results
      setMapPosition results[0].geometry.location, 16
      $("#lat#{id}").val results[0].geometry.location.lat()
      $("#lon#{id}").val results[0].geometry.location.lng()
    else
      alert "Geocode was not successful for the following reason: " + status
    return

window.initialize = (id= "") ->  
  
  map_options = 
     zoom: 8
     center: new google.maps.LatLng 52.904281, -8.023571


  window.map = new google.maps.Map(document.getElementById("map_canvas#{id}"), map_options)
  window.marker = new google.maps.Marker(
      map: map
      position: map_options.center       
      )
  google.maps.event.addListenerOnce map, "idle", ->
    google.maps.event.trigger map, "resize"
    map.setCenter new google.maps.LatLng(52.904281, -8.023571)

  $("a[data-toggle=\"tab\"]").on "shown.bs.tab", (e) ->
    google.maps.event.trigger map, "resize"
    map.setCenter new google.maps.LatLng(52.904281, -8.023571)

window.multiple_maps = ->
  for loc in gon.locations
    console.log loc


setMapPosition = (latlng, zoom = 8) ->
  map.setCenter latlng
  map.setZoom zoom
  marker.setPosition latlng



window.getTab = ->  
  $.ajax #fetch tab from server
    url: '/add-map'
    data: { map: 'hello' }

  

$(document).on 'click', 'a[href="#profile"]', ->
  $.when(getTab()).done ->
    $("[href='#meballs']").tab 'show' #show tab after tab has been rendered
    $("[href='#profile']").hide()



# Run initialize on dom ready if map_container is on screen
$(document).on 'ready page:load', ->  
  if $('#map_container').is(':visible')
    if gon.locations.length == 0
      load_google_maps_api('initialize')
    else
      load_google_maps_api('multiple_maps')   
    
    # checkCoordsSet()
  
    

load_google_maps_api = (name) ->
  script = document.createElement("script")
  script.type = "text/javascript"
  script.src = "https://maps.googleapis.com/maps/api/js?v=3.exp&" + "callback=#{name}"
  document.body.appendChild script