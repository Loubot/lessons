# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
teachersInfoReady = ->  
  #////////// remove fb/twitter share buttons
  $(document).on 'click', '.share_buttons_close', ->
    $('#share_buttons').hide()
# qualification form checkbox
  $('#qualification_present').on 'click', () ->
    if $("#qualification_endDate").css('opacity') is '1'
      $('#qualification_endDate').animate opacity: .1
      $('#qualification_endDate').children().prop disabled: true
    else 
      $('#qualification_endDate').animate opacity: 1
      $('#qualification_endDate').children().prop disabled: false

# end of qualification form checkbox

  # if $('#website-title').length > 0 
    # $('#website-title').css 'margin-left', ($('.collapse.navbar-collapse').width() / 4)
    # $(window).resize ->
    #   $('#website-title').css 'margin-left', ($('.collapse.navbar-collapse').width() / 4)

  $('#qual_left').css('height', $('#qual_form').height())
  if $('#dropzone').length > 0
    # Dropzone.autoDiscover = false
    try
      dropzone = new Dropzone('#dropzone', {
        paramName: "photo[avatar]"
        addRemoveLinks: true
        parallelUploads: 10
        thumbnailWidth: 150
        thumbnailHeight:180
        autoProcessQueue: false
        })  
    
      dropzone.on 'error', (file) ->
        $('body').prepend("<b style='color: red;'>An error occurred while saving the Student.</b>")

      dropzone.on 'sending', (file, xhr, formData) ->
        formData.append 'profile', 'true'
      dropzone.on 'success', (file) ->
        # console.log 'File uploaded successfully'
        location.reload()
      $('#process_queue').on 'click', ->
        dropzone.processQueue()

      
      $('.popover-dismiss').popover({
        trigger: 'focus'
      })
    catch error
      # console.log "Error: #{error}"

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
    bestPictures.clearPrefetchCache()
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

  if $('.review_lesson').length > 0
    $('.review_lesson_input').rating
      filled: "glyphicon glyphicon-thumbs-up"
      empty: "glyphicon glyphicon-thumbs-down"

    $('.review_lesson_input').on 'change', ->
      rating = parseInt($(@).val()) + 1
      $('.rating_value').text (rating) + " thumbs up"
      $(@).closest('.review_lesson').append """<input name="review[rating]" type="hidden" value="#{rating}">"""

        

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
          $('.fav_subjects_container').empty()
          
          $(html).appendTo('.fav_subjects_container').show('slow')
             

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

#//// show_teacher_to_user add price to form modal

  if $('.btn_book_now').length > 0
    # console.log $('#rates').text().replace(/[^\d.]/g,"")
    # console.log """ <input id="event_rate" name="event[rate]" type="hidden" value="#{$('#rates').text()}"> """ 
    $('#create_event_form').append """ <input id="event_rate" name="event[rate]" type="hidden" value="#{ $('#rates').text().replace(/[^\d.]/g,"") }"> """ 
    # $(document).on 'change', '#rates', ->
    #   $('#create_event_form').find('#event_rate').remove()
    # $('#create_event_form').append """ <input id="event_rate" name="event[rate]" type="hidden" value="#{$('#rates').val()}"> """ 

    do () ->
      img = new Image()
      img.src = gon.profile_pic_url
      w = $('.show_teacher_profile_section').outerWidth()
      # console.log w
      $('.profile_pic_container').css 'height', w
      $('.profile_pic_container').css 'width', w
    $(window).resize ->      
      w = $('.show_teacher_profile_section').outerWidth()
      # console.log w
      $('.profile_pic_container').css 'height', w
      $('.profile_pic_container').css 'width', w
      
      # $('.profile_pic_container').css 'background-image', "url(#{img.src})"
    
    
    $('.fotorama').fotorama  #initiate fotorama picture displayer
      width: 333
      transition: "crossfade"
      loop: true
      autoplay: true
      nav: "thumbs"
      allowfullscreen: true
      height: 333
      arrows: true     
      fit: 'cover'
      thumbfit: 'cover'
    # $(".fotorama").on "fotorama:load", (e, fotorama) ->
    #   $('.show_teacher_profile_section').css 'height', $('.fotorama').css 'height'

    $("a[data-toggle=\"tab\"]").on "shown.bs.tab", (e) ->
      # e.target # newly activated tab
      # e.relatedTarget # previous active tab
      $('#address').empty().append gon.locations[$(@).data('index')].address

    #display appropraite booking option from dropdown select in payment_choice_modal
    
    $('#location_choice').on 'change', ->
      if @.value == 'Teachers house'
        $('.select_teachers_location').css 'display', 'inline'
        $('.select_home_lesson').css 'display', 'none'
      else
        $('.select_teachers_location').css 'display', 'none'
        $('.select_home_lesson').css 'display', 'inline'
        

    #// end of display appropraite booking option

  if $('#this_date').length > 0
    AnyTime.noPicker 'this_date'
    $("#this_date").AnyTime_picker
      format: "%Y-%m-%d"
      placement: 'inline'
      hideInput: true




#//// end of show_teacher_to_user add price to form modal

#///////////jquery for popover previous_lessons_teacher
  if ('.previous_lessons_header').length > 0
    $("html").click (e) ->
        $(".review_hover").popover "hide"
        

      $(".review_hover").popover(
        html: true
        trigger: "manual"
        placement: 'left'
      ).click (e) ->
        $('.review_hover').not(this).popover('hide')
        $(this).popover "toggle"
        e.stopPropagation()
  


  # $('.review_hover').mouseleave ->
  #   $(@).popover 'hide'
#////////// end review script previous_lessons_teacher


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