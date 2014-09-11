# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
staticReady = ->
  $('a[href="' + this.location.pathname + '"]').parent().addClass('active')

  $('.dual_registration_container.left').css 'height', $('.dual_registration_container.right').css 'height'


$(document).ready(staticReady)
$(document).on('page:load', staticReady)