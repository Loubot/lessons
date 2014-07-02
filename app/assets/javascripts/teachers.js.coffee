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


	
initialize = ->
  mapCanvas = document.getElementById("map_canvas")
  mapOptions =
    center: new google.maps.LatLng(52.904281, -8.023571)
    zoom: 8
    mapTypeId: google.maps.MapTypeId.ROADMAP

  map = new google.maps.Map(map_canvas, mapOptions)
  google.maps.event.addListener map, "click", (e) ->
	  $('#lat').val(e.latLng.lat())
	  $('#lon').val(e.latLng.lng())
	
	  
	  #optionally mark the location
	  #markLocation e.latLng
  return
		
	$(document).ready ->
		google.maps.event.addDomListener window, 'load', initialize
		
		
	