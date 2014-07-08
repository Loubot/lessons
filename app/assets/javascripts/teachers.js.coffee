# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$(document).on 'page:change', ->
	$('#qual_left').css('height', $('#qual_form').height())
	dropzone = new Dropzone('#dropzone', {
		paramName: "photo[avatar]"
		addRemoveLinks: true
		parallelUploads: 10
		autoProcessQueue: true
		#previewsContainer: ".first_thumbnail"
		# init: ->
		# 	@on "addedfile", (file) ->				
	 #    	$(".row").toggle()

		})

	

	dropzone.on 'error', (file) ->
		$('body').prepend("<b style='color: red;'>An error occurred while saving the Student.</b>")

	dropzone.on 'success', (file) ->
		console.log 'File uploaded successfully'
		location.reload()
#//////////////////////////////////////////////////////////////////////////////
#map
#//////////////////////////////////////////////////////////////////////////////

initialize = ->
  mapCanvas = document.getElementById("map_canvas")
  if gon.location[0] == null && gon.location[1] == null
    alert 'b'
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
		
	$(document).ready ->
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
	alert 'a'
	mapOptions =
	    center: new google.maps.LatLng(gon.location[0], gon.location[1])
	    zoom: 16
	    mapTypeId: google.maps.MapTypeId.ROADMAP
	return mapOptions

setMapPosition = (latlng, zoom = 8) ->
	map.setCenter latlng
	map.setZoom zoom
	marker.setPosition latlng
	