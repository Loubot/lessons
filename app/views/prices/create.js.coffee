window.emptyDiv = ->
  $(".price_alert").css 'visibility', 'hidden'
  $(".price_alert").empty()
  window.isSet = 0

window.delay = ->
  timer = setTimeout (->
    emptyDiv()
    window.isSet = 1
  ), 2000



timer = undefined
if not window.isSet? then window.isSet = 0
if $('.price_alert').length 
  $('.price_alert').prepend """ <p class="price_alert_message"> <%= @name %> price updated </p> """
  $('.price_alert').css 'visibility', 'visible'
  if window.isSet is 1
    clearTimeout(timer)
    delay()
  else
    delay()




