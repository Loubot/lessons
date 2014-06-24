# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$(document).on 'page:change', ->
	$('#calendar').fullCalendar
		
		defaultView: 'agendaWeek'
	dropzone = new Dropzone('#my_dropzone', {
		addRemoveLinks: true
		url: 'files/post'
		parallelUploads: 10
		addRemoveLinks: true
		autoProcessQueue: false
		})

	