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
  
#////////////Root page subject search with typeahead
  if $('.typeahead.subject').length > 0
    bestPictures = new Bloodhound(
      datumTokenizer: Bloodhound.tokenizers.obj.whitespace("name")
      queryTokenizer: Bloodhound.tokenizers.whitespace
      prefetch: "/subject-search"
    )
    bestPictures.initialize()
    $(".typeahead.subject").typeahead 
      hint: true
      highlight: true
      minLength: 2
    ,        
      name: "Subjects"
      displayKey: "name"
      source: bestPictures.ttAdapter()

  if $('.typeahead.county').length > 0
    countyList = getCounties()
    counties = new Bloodhound(
      datumTokenizer: Bloodhound.tokenizers.obj.whitespace("value")
      queryTokenizer: Bloodhound.tokenizers.whitespace    
      local: $.map(getCounties(), (county) ->
        value: county)
    )  
    counties.initialize()
    $(".typeahead.county").typeahead
      hint: true
      highlight: true
      minLength: 1
    ,
      name: "counties"
      displayKey: "value"      
    
      source: counties.ttAdapter()
  $(document).on 'change', '.form-control.distance_rate', ->
    $('#main_subject_search').submit()
    
#///////////End of root page subject search with typeahead

#///////////////Teachers subject search
  $('#subject_search').keyup ->
    $.get($('#subject_search').attr('action'), $('#subject_search').serialize(), null, 'script')

#///////////////End of teachers subject_search

  
#///////////////Autofocus teachers subject search input field
  $('#teachers_subjects_modal').on 'shown.bs.modal', ->
    document.getElementById('teachers_search_input').focus()
	#///////////////End of autofocus function

#/////////////search results page
  if $('.search_results_row').length > 0
    $('.search_results_left').css 'height', $('.results_photos').css 'height'
		$('.search_restuls_right').each ->			
			$('.search_restuls_right').css 'height', $('.search_results_left').css 'height'

		$('.search_results_row').mouseover ->
			$('.image_container').css 'color', 'black'
			$(@).find('.search_results_teachers_name').animate color: '#509BE6',50
			$('.image_container').css 'text-decoration', 'none'
			$(this).find('.results_photos.back').animate opacity: .5, 50
		$('.search_results_row').mouseleave ->
			$('.image_container').css 'color', 'black'
			$(@).find('.search_results_teachers_name').animate color: 'black',50
			$(this).find('.results_photos.back').animate opacity: 0, 50
		
		#////////////end of search results page


#////////////////Teachers area block book checkbox
$(document).on 'change', '#Multiple', ->
	
	$('#no_of_weeks').animate height: 'toggle', 100
	
		
#///////////////End of Teachers area block book checkbox


$(document).ready(teachersInfoReady)
$(document).on('page:load', teachersInfoReady)



getCounties = () ->
  return ['Antrim','Armagh','Carlow','Cavan','Clare','Cork','Derry','Donegal','Down','Dublin',
          'Fermanagh','Galway','Kerry','Kildare','Kilkenny','Laois','Leitrim','Limerick','Longford',
          'Louth','Mayo','Meath','Monaghan','Offaly','Roscommon','Sligo','Tipperary','Tyrone',
          'Waterford','Westmeath','Wexford','Wicklow']