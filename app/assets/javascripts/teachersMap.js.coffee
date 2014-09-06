
#////////////////////////////show teachers map
initialise_show_teachers_map = ->
  mapCanvas = document.getElementById('teacher_display_map')
  mapOptions = setMapOptions()
  mapOptions.zoom = 14 #override setMapOptions zoom level

  window.map = new google.maps.Map(mapCanvas, mapOptions)

  circleOptions = 
    strokeColor: '#FF0000'
    strokeOpacity: .8
    strokeWeight: 2
    fillColor: '#FF0000'
    fillOpacity: .35
    map: map
    center: mapOptions.center
    radius: 200

  googleCircle = new google.maps.Circle(circleOptions)
#///////////////////////////end of show teachers map

#////////////////////////////teachers info map
initialize = ->
  mapCanvas = document.getElementById("map_canvas")
  if gon.location[0] == null && gon.location[1] == null
    mapOptions = 
      center: new google.maps.LatLng(52.904281, -8.023571)
      zoom: 8
      mapTypeId: google.maps.MapTypeId.ROADMAP
  else
    mapOptions = setMapOptions()
  
  window.map = new google.maps.Map(mapCanvas, mapOptions)
  window.marker = new google.maps.Marker(
        map: map
        position: mapOptions.center       
        )
  google.maps.event.addListener map, "click", (e) ->
    lat = e.latLng.lat()
    lon = e.latLng.lng()
    $('#lat').val(e.latLng.lat())
    $('#lon').val(e.latLng.lng())
    setMapPosition e.latLng, map.getZoom()

    #optionally mark the location
    #markLocation e.latLng
  return
  
  

window.start_address_search = () ->
  geocoder = new google.maps.Geocoder()
  geocoder.geocode address: $('#address').val(), (results, status) ->
    if status is google.maps.GeocoderStatus.OK
      setMapPosition results[0].geometry.location, 16
      $('#lat').val results[0].geometry.location.lat()
      $('#lon').val results[0].geometry.location.lng()
    else
      alert "Geocode was not successful for the following reason: " + status
    return
  
setMapOptions = () ->
  mapOptions =
    center: new google.maps.LatLng(gon.location[0], gon.location[1])
    zoom: 16
    mapTypeId: google.maps.MapTypeId.ROADMAP
  return mapOptions

setMapPosition = (latlng, zoom = 8) ->
  map.setCenter latlng
  map.setZoom zoom
  marker.setPosition latlng
  
checkCoordsSet = () ->
  if gon.location[0] == null && gon.location[1] == null
    $('.coordsHinter').css('visibility', 'visible')

#//////////end of teachers info map

# Run initialize on dom ready if map_container is on screen
$(document).on 'ready page:load', ->  
  if $('#map_container').is(':visible')
    initialize()
    checkCoordsSet()
  else if $('#teacher_display_map').is(':visible')
    initialise_show_teachers_map()