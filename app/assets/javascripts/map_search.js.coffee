ready = ->
  if $('#search_map').is(':visible') or $('#grind_map_container').is(':visible')
    window.url = if $('#search_map').is(':visible') then 'display-subjects' else 'grinds'
    window.map_id = if $('#search_map').is(':visible') then  'search_map' else 'grind_map_container'
    console.log map_id
    window.first_load = true
    $.when(load_google_maps_api()).done ->

map_changed = ->
  
  if window.first_load != true
    
    console.log "map changed"
    # console.log "map #{search_map.getBounds()}"
    grindCentral =  search_map.getCenter()

    bounds = search_map.getBounds()
    console.log bounds
    center = bounds.getCenter()
    ne = bounds.getNorthEast()

    r = 3960

    lat1 = center.lat() / 57.2958
    lon1 = center.lng() / 57.2958
    lat2 = ne.lat() / 57.2958
    lon2 = ne.lng() / 57.2958
    dis = r * Math.acos(Math.sin(lat1) * Math.sin(lat2) + 
     Math.cos(lat1) * Math.cos(lat2) * Math.cos(lon2 - lon1))
    console.log dis
    dis = dis * .8
    # console.log dis

    $.ajax(
      method: 'get'
      dataType: 'script'
      url: url
      data:       
        lat: grindCentral.lat()
        lon: grindCentral.lng()
        distance: dis
        search_subjects: getQueryParam("search_subjects")
        search_position: getQueryParam("search_position") )
  window.first_load = false
  


window.init_search_map = ->
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
  
  window.search_map = new (google.maps.Map)(document.getElementById(map_id), mapOptions)
 

  if (gon)? and (gon.locations)?

   
    
    for loc in gon.locations
      # console.log loc.longitude
      latLng =  
        lat: loc.latitude
        lng: loc.longitude

      marker = new (google.maps.Marker)(
          position: latLng
          map: search_map
          title: 'Grinds maps'
        )

      markersArray.push marker
  # console.log "markersArray #{markersArray}"

  # google.maps.event.addListener search_map, "dragend", ->    
  #   map_changed()

  # google.maps.event.addListener search_map, "zoom_changed", ->
  #   map_changed()

  google.maps.event.addListener search_map, "idle", ->
    map_changed()
        
    

load_google_maps_api = ->
  if !(google?) #if google maps not loaded   
  
    console.log 'loading Google maps'
    script = document.createElement("script")
    script.type = "text/javascript"
    script.src = "https://maps.googleapis.com/maps/api/js?key=AIzaSyBpOd04XM28WtAk1LcJyhlQzNW6P6OT2Q0&callback=init_search_map"
    document.body.appendChild script
  else
    init_search_map()
    console.log 'Google maps already loaded'



$(document).ready ready
$(document).on 'page:load', ready
$(window).unload(ready)