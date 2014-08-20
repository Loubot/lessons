# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
teachersInfoReady = ->
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
  if $('#dropzone').length > 0
    dropzone = new Dropzone('#dropzone', {
      paramName: "photo[avatar]"
      addRemoveLinks: true
      parallelUploads: 10
      thumbnailWidth: 274
      thumbnailHeight:180
      autoProcessQueue: false
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

  if $('#main_subject_search').length > 0
    alert 'b'
    $.ajax
      url: $('#main_subject_search').attr('action')
      data:  $('#main_subject_search').serialize()
      dataType: 'json'
      success: (data) ->
        console.log data
        window.data = data
        $('#main_subject_search_textfield').typeahead
          hint: true
          highlight: true
          minLength: 1
        ,
          source: data

        

#///////////////End of teachers subject_search


#////////////Apply typeahead to teachers subject search
  # $('#main_subject_search').typeahead 
  #   source: resultsData

#////////////End of typeahead


	#///////////////Autofocus teachers subject search input field
	$('#teachers_subjects_modal').on 'shown.bs.modal', ->
		document.getElementById('teachers_search_input').focus()
	#///////////////End of autofocus function

#/////////////search results page
	if $('.search_results_row').length > 0		
		# navigator.geolocation.getCurrentPosition (pos) ->
		# 	alert JSON.stringify pos
		$('.search_results_left').css 'height', $('.results_photos').css 'height'
		$('.search_restuls_right').each ->			
			$('.search_restuls_right').css 'height', $('.search_results_left').css 'height'

		$('.search_results_row').mouseover ->
			$('.image_container').css 'color', 'black'
			$(@).find('.search_results_teachers_name').animate color: '#509BE6',50
			$('.image_container').css 'text-decoration', 'none'
			$(this).find('.results_photos.back').animate opacity: .7, 50
		$('.search_results_row').mouseleave ->
			$('.image_container').css 'color', 'black'
			$(@).find('.search_results_teachers_name').animate color: 'black',50
			$(this).find('.results_photos.back').animate opacity: 0, 50
		
		#////////////end of search results page


#////////////////Teachers area block book checkbox
$(document).on 'change', '#Multiple', ->
	if !($('#no_of_weeks').is ':visible')
		$('#no_of_weeks').css 'display', 'inline'
	else
		$('#no_of_weeks').css 'display', 'none'
		
#///////////////End of Teachers area block book checkbox


$(document).ready(teachersInfoReady)
$(document).on('page:load', teachersInfoReady)