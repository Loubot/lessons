window.init_teachers_maps = ->
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

  setMapPosition = (latlng, zoom = 8) ->
    map.setCenter latlng
    map.setZoom zoom
    marker.setPosition latlng


  window.initialize = (id= "") ->
    # console.log id
    
    map_options = 
      zoom: 8
      center: new google.maps.LatLng 52.904281, -8.023571


    window.map = new google.maps.Map(document.getElementById("map_canvas#{id}"), map_options)
    window.marker = new google.maps.Marker(
        map: map
              
        )
    google.maps.event.addListenerOnce map, "idle", ->
      google.maps.event.trigger map, "resize"
      map.setCenter new google.maps.LatLng(52.904281, -8.023571)



    google.maps.event.addListener map, "click", (e) ->
      geocoder = new google.maps.Geocoder()
      geocoder.geocode location: e.latLng, (results, status) ->
        if status is google.maps.GeocoderStatus.OK
          # console.log results[0].formatted_address
          $("#address#{id}").val results[0].formatted_address
        marker.position = e.latLng
          
      lat = e.latLng.lat()
      lon = e.latLng.lng()
      $('#lat_edit').val(e.latLng.lat())
      $('#lon_edit').val(e.latLng.lng())
      setMapPosition e.latLng, map.getZoom()


  window.multiple_maps = ->
    
    for loc, i in gon.locations
      # console.log "map_canvas#{i}"
      map_options = 
        zoom: 16
        center: new google.maps.LatLng loc.latitude, loc.longitude
      
      map = new google.maps.Map(document.getElementById("map_canvas#{i}"), map_options)
      mapArray.push map
      mapOptionsArray.push map_options
      # marker = new google.maps.Marker(
      #   map: map
      #   position: map_options.center )
      populationOptions = 
        strokeColor: '#FF0000'
        strokeOpacity: 0.8
        strokeWeight: 2
        fillColor: '#FF0000'
        fillOpacity: 0.35
        map: map
        center: map_options.center
        radius: 100
      # Add the circle for this city to the map.
      cityCircle = new (google.maps.Circle)(populationOptions)
    # console.log mapArray

  window.doNothin = ->
  console.log "Maps loaded"


  window.getTab = ->  
    $.ajax #fetch tab from server
      url: '/add-map'
      

    
  $("a[data-toggle=\"tab\"]").on "shown.bs.tab", (e) ->
    if $(@).data 'index'
      # console.log $(@).data 'index'
      i = $(@).data 'index'
      map = mapArray[i]
      google.maps.event.trigger map, "resize"
      map.setCenter mapOptionsArray[i].center
    
  $(document).on 'click', 'a[href="#profile"]', ->
    $.when(getTab()).done -> #call getTab
      $("[href='#meballs']").tab 'show' #show tab after tab has been rendered
      $("[href='#profile']").hide()



# Run initialize on dom ready if map_container is on screen


ready = ->
  if $('#map_container').is(':visible')
    window.mapArray = []
    window.mapOptionsArray = []
    if gon.locations.length == 0
      $.when(load_google_maps_api()).done ->
        init_teachers_maps()
    else
      $.when(load_google_maps_api('multiple_maps')).done ->
        init_teachers_maps()
  else if $('.show_teacher_profile_container').length > 0
    window.mapArray = []
    window.mapOptionsArray = []
    $.when(load_google_maps_api('multiple_maps')).done ->
      init_teachers_maps()
    
    
    # checkCoordsSet()
  


load_google_maps_api = (name) ->
  if (google?) #if google maps already loaded
    console.log 'Google maps already loaded'
    window[name]() #turn string into function call
    return

  callback = (if (name?) then "callback=#{name}" else "callback=doNothin")
  console.log 'loading'
  script = document.createElement("script")
  script.type = "text/javascript"
  script.src = "https://maps.googleapis.com/maps/api/js?v=3.exp&" + callback
  document.body.appendChild script



$(document).ready ready
$(document).on 'page:load', ready