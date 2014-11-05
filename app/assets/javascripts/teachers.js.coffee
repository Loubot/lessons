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
    $('#main_subject_search').on 'keypress', (e) ->
      e.preventDefault() if e.which == 13

    bestPictures = new Bloodhound(
      datumTokenizer: Bloodhound.tokenizers.obj.whitespace("name")
      queryTokenizer: Bloodhound.tokenizers.whitespace
      prefetch: 
        url: "/subject-search"
        ttl: 3600000
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

#///////////////Autofocus on login modal
  if $('#login_modal_email').length > 0
    $('#login_modal').on 'shown.bs.modal', ->
      document.getElementById('login_modal_email').focus()

#//////////////End of autofocus on login modal

#///////////////Autofocus teachers subject search input field
  if $('#teachers_subjects_modal').length > 0
    $('#teachers_subjects_modal').on 'shown.bs.modal', ->
      document.getElementById('teachers_search_input').focus()
#///////////////End of autofocus function

#/////////////search results page
  if $('.search_results_row').length > 0

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

# ///////////welcome page
  if $(".stock_photos_container").length > 0
    h = $('#main_page').height()
    $('#main_page').height(h)
    
    #/// ajax load browse options
    $(document).on 'click', '.browse_option', (e) ->
      $('.browse_option').removeClass 'btn btn-success'
      $(@).addClass 'btn btn-success'
      e.preventDefault()
      $.ajax
        url: 'refresh-welcome'
        data: { page: $(@).attr('id') }
        type: 'get'
        success: (html) ->
          $('.stock_photos_container').empty()
          
          $(html).appendTo('.stock_photos_container').show('slow')
          return false 
            
      return false

    $('.stock_photo_container').mouseover ->
      $(this).find('.welcome_subject_image').animate opacity: .7, 50

    $('.stock_photo_container').mouseleave ->
      $(@).find('.welcome_subject_image').animate opacity: 0, 50
# //////////end of welcome page

#////////// teachers/form photo partial enable dismissable popover
  if $('.profile_pic_popover').length > 0
    $("html").click (e) ->
      $(".profile_pic_popover").popover "hide"
      

    $(".profile_pic_popover").popover(
      html: true
      trigger: "manual"
    ).click (e) ->
      $('.profile_pic_popover').not(this).popover('hide')
      $(this).popover "toggle"
      e.stopPropagation()
      
    
#////////// end of teachers/form photo partial enable dismissable popover


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