# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$(document).on 'page:change', ->
	$('#qual_left').css('height', $('#qual_form').height())
	dropzone = new Dropzone('#dropzone', {
		paramName: "photo[avatar]"
		addRemoveLinks: true
		parallelUploads: 10
		thumbnailWidth: 274
		thumbnailHeight:180
		autoProcessQueue: true
		#previewsContainer: ".first_thumbnail"
		# init: ->
		# 	@on "addedfile", (file) ->				
	 #    	$(".row").toggle()

		})

	

	dropzone.on 'error', (file) ->
		$('body').prepend("<b style='color: red;'>An error occurred while saving the Student.</b>")

	dropzone.on 'sending', (file, xhr, formData) ->
		formData.append 'profile', 'true'
	dropzone.on 'success', (file) ->
		console.log 'File uploaded successfully'
		location.reload()
#//////////////////////////////////////////////////////////////////////////////
