# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$(document).on 'page:change', ->	
	dropzone = new Dropzone('#dropzone', {
		paramName: "photo[avatar]"
		addRemoveLinks: true
		parallelUploads: 10
		autoProcessQueue: true
		})

	dropzone.on 'error', (file) ->
		$('body').prepend("<b style='color: red;'>An error occurred while saving the Student.</b>")

	dropzone.on 'success', (file) ->
		console.log 'File uploaded successfully'



	