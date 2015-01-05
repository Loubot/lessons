window.initialize = (id= "") ->  
  
  map_options = 
     zoom: 8
     center: new google.maps.LatLng 52.904281, -8.023571


  map = new google.maps.Map(document.getElementById("map_canvas#{id}"), map_options)
  window.marker = new google.maps.Marker(
      map: map
      position: map_options.center       
      )
  google.maps.event.addListenerOnce map, "idle", ->
    google.maps.event.trigger map, "resize"
    map.setCenter new google.maps.LatLng(52.904281, -8.023571)

  $("a[data-toggle=\"tab\"]").on "shown.bs.tab", (e) ->
    alert 'b'
    google.maps.event.trigger map, "resize"
    map.setCenter new google.maps.LatLng(52.904281, -8.023571)








window.getTab = ->  
  $.ajax 
    url: '/add-map'
    data: { map: 'hello' }

  

$(document).on 'click', 'a[href="#profile"]', ->
  $.when(getTab()).done ->
  



# Run initialize on dom ready if map_container is on screen
$(document).on 'ready page:load', ->  
  if $('#map_container').is(':visible')      
    load_google_maps_api('initialize')
    # checkCoordsSet()
  
    

load_google_maps_api = (name) ->
  script = document.createElement("script")
  script.type = "text/javascript"
  script.src = "https://maps.googleapis.com/maps/api/js?v=3.exp&" + "callback=#{name}"
  document.body.appendChild script