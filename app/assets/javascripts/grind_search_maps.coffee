ready = ->
  if $('#grind_map_container').is(':visible')
    window.first_load = true
    $.when(load_google_maps_api_grinds()).done ->

map_changed = ->
  if window.first_load != true
    console.log "map changed"
    grindCentral =  grinds_map.getCenter()
    bounds = grinds_map.getBounds()
    center = bounds.getCenter()
    ne = bounds.getNorthEast()

    r = 3960

    lat1 = center.lat() / 57.2958
    lon1 = center.lng() / 57.2958
    lat2 = ne.lat() / 57.2958
    lon2 = ne.lng() / 57.2958
    dis = r * Math.acos(Math.sin(lat1) * Math.sin(lat2) + 
     Math.cos(lat1) * Math.cos(lat2) * Math.cos(lon2 - lon1))
    dis = dis * .8
    # console.log "distance #{ dis }"

    $.ajax(
      method: 'get'
      dataType: 'script'
      url: 'grinds'
      data:        
        lat: grindCentral.lat()
        lon: grindCentral.lng()
        distance: dis
        search_subjects: getQueryParam("search_subjects") )
  window.first_load = false
  
redraw_markers = (data) ->
  # console.log "locations #{ JSON.stringify data }"
  for marker in window.markersArray
    marker.setMap(null)

  console.log data['locations'].length
  for loc in data['locations']
    # console.log "latitude #{ loc.longitude }"
    latLng = new google.maps.LatLng loc.latitude, loc.longitude
    # console.log latLng
    marker = new google.maps.Marker(
      position: latLng
      map: grinds_map
      title: loc.name
      )
    # console.log marker
    marker.setMap(grinds_map)
    markersArray.push marker


window.init_grinds_map = ->
  window.markersArray = null
  window.markersArray = new Array()
  if (gon?) and (gon.initial_location?)
    mapOptions = 
      center: new google.maps.LatLng(gon.initial_location.lat, gon.initial_location.lon)
      zoom: 8
  else
    mapOptions = 
      center: new google.maps.LatLng(52.904281, -8.023571)
      zoom: 7

  window.grinds_map = new (google.maps.Map)(document.getElementById('grind_map_container'),mapOptions)
  

  window.markersArray = new Array()
  
  for loc in gon.locations
    # console.log loc.longitude
    latLng =  
      lat: loc.latitude
      lng: loc.longitude

    marker = new (google.maps.Marker)(
        position: latLng
        map: grinds_map
        title: 'Grinds maps'
      )

    markersArray.push marker

  # google.maps.event.addListener grinds_map, "dragend", ->    
  #   map_changed()

  # google.maps.event.addListener grinds_map, "zoom_changed", ->
  #   map_changed()

  google.maps.event.addListener grinds_map, "idle", ->
    map_changed()
        
    

load_google_maps_api_grinds = ->
  if !(google?) #if google maps not loaded   
  
    console.log 'loading Google maps'
    script = document.createElement("script")
    script.type = "text/javascript"
    script.src = "https://maps.googleapis.com/maps/api/js?key=AIzaSyBpOd04XM28WtAk1LcJyhlQzNW6P6OT2Q0&callback=init_grinds_map"
    document.body.appendChild script
  else
    console.log 'Google maps already loaded'



$(document).ready ready
$(document).on 'page:load', ready


getQueryParam = (param) ->
  result = window.location.search.match(new RegExp('(\\?|&)' + param + '(\\[\\])?=([^&]*)'))
  if result then result[3] else false