
		#map
#//////////////////////////////////////////////////////////////////////////////

initialize = ->
  mapCanvas = document.getElementById("map_canvas")
  if gon.location[0] == null && gon.location[1] == null
    mapOptions = 
      center: new google.maps.LatLng(52.904281, -8.023571)
      zoom: 8
      mapTypeId: google.maps.MapTypeId.ROADMAP
  else
    mapOptions = setMapOptions()
  
  window.map = new google.maps.Map(map_canvas, mapOptions)
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
	
	# Run initialize on dom ready if map_container is on screen
	$(document).ready ->
		if $('#map_container').length > 0
			google.maps.event.addDomListener window, 'load', initialize

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
	