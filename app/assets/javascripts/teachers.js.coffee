# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
teachersInfoReady = ->
  $.cookieBar(
    declineButton: true
    
  )
  
  if !(jQuery.cookieBar('cookies'))
    $('#share_buttons').empty()
    $('#share_buttons').hide()
    $('#mobile_share_buttons').empty()
    $('#mobile_share_buttons').hide()
  
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

  # if $('#website-title').length 
    # $('#website-title').css 'margin-left', ($('.collapse.navbar-collapse').width() / 4)
    # $(window).resize ->
    #   $('#website-title').css 'margin-left', ($('.collapse.navbar-collapse').width() / 4)

  $('#qual_left').css('height', $('#qual_form').height())

  if $('#dropzone').length 

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
  if $('.typeahead.subject').length
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


  if $('.typeahead.county').length
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

  if $('.review_lesson').length
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
  if $('#login_modal_email').length
    $('#login_modal').on 'shown.bs.modal', ->
      document.getElementById('login_modal_email').focus()

#//////////////End of autofocus on login modal

#///////////////Autofocus teachers subject search input field
  if $('#teachers_subjects_modal').length
    $('#teachers_subjects_modal').on 'shown.bs.modal', ->
      document.getElementById('teachers_search_input').focus()
#///////////////End of autofocus function

#/////////////search results page
  if $('.search_results_row').length

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
  if $(".stock_photos_container").length
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
  if $('.profile_pic_popover').length
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

  if $('.btn_book_now').length
    if (gon.teacher_id?)
      if (window.ga?)
        ga('create', 'UA-57834504-3', 'auto')
    #////////////////Teachers area block book checkbox
    $(document).on 'change', '#Multiple', ->

      $('#no_of_weeks').animate height: 'toggle', 100

    #///////////////End of Teachers area block book checkbox
    $(document).on 'submit', '#create_event_form', (e) -> #stop event form to check week no is valid
      
      e.preventDefault()
      if ($('#no_of_weeks').val() == '' && $('#Multiple').prop 'checked')
        $('#no_of_weeks').addClass 'select_error'
      else

        $.post($(@).attr('action'), $(@).serialize()) #submit form remotely
    #end of submit create_event_form

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
    
    #initiate fotorama picture displayer
    $('.fotorama').fotorama  
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
    

    $("a[data-toggle=\"tab\"]").on "shown.bs.tab", (e) ->
      # e.target # newly activated tab
      # e.relatedTarget # previous active tab
      $('#address').empty().append gon.locations[$(@).data('index')].address

    #display appropraite booking option from dropdown select in payment_choice_modal
    
    if $('#location_choice').length
      document.getElementById("location_choice").selectedIndex = 0
    $('#location_choice').on 'change', ->
      if @.value == 'Teachers house'
        $('.select_teachers_location').css 'display', 'inline'
        $('.select_home_lesson').css 'display', 'none'
      else
        $('.select_teachers_location').css 'display', 'none'
        $('.select_home_lesson').css 'display', 'inline'
        

    #// end of display appropraite booking option

    #the_one_modal
    if $('#the_one_modal').length
      $('#the_one_modal').on 'hidden.bs.modal', ->
        $('.payment_form_container').empty()
        $('.display_teachers_location').empty()
        $('.returned_locations_container').empty()
        
      $('#the_one_modal').on 'shown.bs.modal', ->
        $('.payment_form_container').empty()
        $("select").each ->
          $(this).val($(this).find('option[selected]').val())
        
      # document.getElementById("select_subject").selectedIndex = 0     
      $(document).on 'change', '.select_subject', ->
        $('.select_subject').submit()
        # $.ajax
        #   url: 'get-locations'
        #   data:            
        #     subject_id: $('.select_subject').val()
        #     id: $('#select_subjects_teacher_id').val()

      $(document).on 'change', '.select_home_or_location', ->
        $('.location_choice').val $('.select_home_or_location').val()
        $('.subject_id').val $('.select_subject').val()
        $('.get_subjects_form').submit()
        # $.ajax
        #   url: 'get-subjects'
        #   data:
        #    id: $('#select_subjects_teacher_id').val()
        #    subject_id: $('.select_subject').val()
        #    location_choice: $('.select_home_or_location').val()
      
      # $(document).on 'click', '#location_only_datepicker', ->
      #   console.log 'a'
      #   AnyTime.noPicker 'location_only_datepicker'
      #   $("#location_only_datepicker").AnyTime_picker
      #     format: "%Y-%m-%d"
      #     placement: 'inline'
      #     hideInput: true

      $(document).on 'change', '.teachers_location_selection', ->
        $('.teachers_locations_subject').val $('.select_subject').val()
        $('.get_locations_price_form').submit()
        # $.ajax
        #   url: 'get-locations-price'
        #   data:
        #     id: $('#select_subjects_teacher_id').val()
        #     subject_id: $('.select_subject').val()
        #     location_id: $('.teachers_location_selection').val()

    # end of the_one_modal

    

    $(document).on 'submit', '.home_booking_form', (e) -> #prevent paypal for submitting
      
      e.preventDefault()      
      
      address = null
      
      
      $('.home_address').val $('#home_booking_address').val() #append address to booking form

      if $('#remember').is ':checked'
        $('.save_address').val 'true' #set value of hidden field to tell server to save address
      else
        $('.save_address').val 'false'
        
      address = $('#home_booking_address').val() 
      if !address #alert user if no address entered
        alert "Address cannot be blank" 
      else 
        @.submit()

    $(document).on 'click', '.stripe-button-el', ->  #function on stripe button click. 
      
      $('.home_address').val $('#home_booking_address').val()
      if $('#remember').is ':checked'
        
        $('.save_address').val 'true'
      else
        
        $('.save_address').val 'false'

        # append package id to packages modal when packages modal is opened
    $('#payment_packages_modal').on 'shown.bs.modal', ->
      
      $('.package_booking_form').append """ 
                        <input type="hidden" name="package_id" class="package_id" value="#{ $('.package_select_box').val() }"> 
                                    """

    $(document).on 'change', '.package_select_box', ->
      
        #change package_id passed to controller when dropdown menu is changed
      $('.package_id').val $(@).val()




#//// end of show_teacher_to_user add price to form modal

#///////////jquery for popover previous_lessons_teacher
  if ('.previous_lessons_header').length

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
#////////// end review script previous_lessons_teacher

  # teachers business page, add subject name to for before submitting
  if $('.create_package_form')
    $('.create_package_form').submit (e)->
      e.preventDefault()
      subject_name = $('.package_subject_name :selected').text()
      $('.create_package_form').append """ 
                  <input value="#{ subject_name }" type="hidden" name="package[subject_name]">
                                        """      
      @.submit()
  if $(".grind_form")
    $(".grind_form").submit (e) ->
      e.preventDefault()
      subject_name = $(".grind_subject_name :selected").text()
      $(".grind_form").append """
                    <input value="#{ subject_name }" type="hidden" name="grind[subject_name]">
                                 """
      @.submit()

#end of  teachers business page, add subject name to for before submitting




$(document).on('ready', teachersInfoReady)
$(document).on('page:load', teachersInfoReady)
$(window).unload(teachersInfoReady)

getCounties = () ->
  return ['Antrim','Armagh','Carlow','Cavan','Clare','Cork','Derry','Donegal','Down','Dublin',
          'Fermanagh','Galway','Kerry','Kildare','Kilkenny','Laois','Leitrim','Limerick','Longford',
          'Louth','Mayo','Meath','Monaghan','Offaly','Roscommon','Sligo','Tipperary','Tyrone',
          'Waterford','Westmeath','Wexford','Wicklow']    