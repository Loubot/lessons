# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$(document).on 'page:change', ->
	# qualification form checkbox
	$('#qualification_present').on 'click', () ->
		if $("#qualification_endDate").css('opacity') is '1'
			$('#qualification_endDate').animate opacity: .1
			$('#qualification_endDate').children().prop disabled: true
		else 
		  $('#qualification_endDate').animate opacity: 1
		  $('#qualification_endDate').children().prop disabled: false

	# end of qualification form checkbox

	$('#qual_left').css('height', $('#qual_form').height())
	dropzone = new Dropzone('#dropzone', {
		paramName: "photo[avatar]"
		addRemoveLinks: true
		parallelUploads: 10
		thumbnailWidth: 274
		thumbnailHeight:180
		autoProcessQueue: false
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
	$('#process_queue').on 'click', ->
    dropzone.processQueue()

  $('.profile_pic_popover').popover()
  $('.popover-dismiss').popover({
	  trigger: 'focus'
	})

#/////////////Qualifications visibility checkbox
	$('#visible_check').on 'click', () ->
		if $('#endDate').css('opacity') is '1'
			$('#endDate').animate opacity: .1
		else
		  $('#endDate').animate opacity: 1
#/////////////End of qualifications visibility checkbox

#///////////////Teachers subject search
	$('#subject_search').keyup ->
		$.get($('#subject_search').attr('action'), $('#subject_search').serialize(), null, 'script')


#////////////////Teachers area block book checkbox
$(document).on 'change', '#Multiple', ->
	if !($('#no_of_weeks').is ':visible')
		$('#no_of_weeks').css 'display', 'inline'
	else
		$('#no_of_weeks').css 'display', 'none'
		
#///////////////End of Teachers area block book checkbox




