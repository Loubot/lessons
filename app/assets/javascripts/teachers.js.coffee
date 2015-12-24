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
        autoProcessQueue: true
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

  $('#mobile_pic_upload').on 'click', () ->
    $('#mobile_pic_form').submit()

#/////////////Qualifications visibility checkbox
  $('#visible_check').on 'click', () ->
    if $('#endDate').css('opacity') is '1'
      $('#endDate').animate opacity: .1
    else
      $('#endDate').animate opacity: 1
#/////////////End of qualifications visibility checkbox
  
#////////////Root page subject search with typeahead
  if $('.typeahead.subject').length
    $('#search_submit').on 'keypress', (f) ->
      if f.which == 13
        console.log "bb"
        $('#main_subject_search').submit()
        
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
  # $(document).on 'click', '.no_subject_found', ->
  #   $('#teachers_subjects_modal').modal 'hide'
  #   $('#teacher_create_subject_modal').modal
  #     show: true
  #     remote: "/create-new-subject?id=#{gon.teacher_id}"
    
  $('#teachers_subjects_modal').on 'shown.bs.modal', ->
    $('#search_results').empty()
    $("#teachers_search_input").val ''
  $('#subject_search').keyup ->
    if $('#teachers_search_input').val().length > 1
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

    $('.welcome_fotorama').fotorama
      # width: "100%"
      # height: "100%"
      transition: "crossfade"
      loop: true
      autoplay: false
      nav: false
      allowfullscreen: true
      
      arrows: true     
      # fit: 'cover'
      # thumbfit: 'cover'
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
      AnyTime.noPicker 'home_lesson_datepicker' #activate anytime datepicker
      $("#home_lesson_datepicker").AnyTime_picker
        format: "%Y-%m-%d"
        placement: 'inline'
        hideInput: true
      $('#the_one_modal').on 'hidden.bs.modal', ->
        $('.check_availabilty_form_container').html ""
        $('.location_only_price_select').css 'display', 'none'
        $('.home_only_avail_times').css "display", 'none'
        $('.payment_choice_error').remove()
        $("select").each -> #set all selects to 0 position
          $(this).val($(this).find('option[selected]').val())


          #home only. display availability form after selecting price
    $(document).on 'change', '.home_only_price_select', ->
      if $('.home_only_price_select')[0].selectedIndex != 0
        $('.home_only_avail_times').css 'display', 'inline'


        #location only select location id
    $(document).on 'change', '.location_only_select', ->
      if $('.location_only_select')[0].selectedIndex != 0
        $.post '/user_carts/1/loc-only-prices',
          { 'user_cart[location_id]': $('.location_only_select').val(),
          'user_cart[teacher_id]': $('#user_cart_teacher_id').val(),
          'user_cart[subject_id': $('#user_cart_subject_id').val() },
          'script'

    $(document).on 'change', '.select_home_or_location', -> #submit choice of home or location
      if $('.home_or_location_select_tag')[0].selectedIndex != 0
        $('.select_home_or_location').submit()



    # end of the_one_modal

    

    $(document).on 'submit', '.home_booking_form', (e) -> #prevent paypal for submitting
      
      e.preventDefault()
      
      address = null
      
      
      $('.home_address').val $('#home_booking_address').val() #append address to booking form

      if $('#hello_check_box').is ':checked'
        console.log 'yes'
        $('.save_address').val "Remember address" #set value of hidden field to tell server to save address
      else
        console.log 'no'
        $('.save_address').val 'false'
      
      
      address = $('.home_address').val()
      if !address #alert user if no address entered
        alert "Address cannot be blank" 
      else 
        @.submit()

    $(document).on 'click', '.stripe-button-el', ->  #function on stripe button click.

      
     
      $('.home_address').val $('#home_booking_address').val() #append address to booking form

      console.log $('.home_address').val()

      if $('#hello_check_box').is ':checked'
        console.log 'yes'
        $('.home_booking_form').prepend """ <input type="hidden" name="remember" id="remember" class="save_address" value="Remember address"> """
      else
        console.log 'no'
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

  if $('.home_schooling')
    $('.show_home_schooling_content').on 'click',  -> #show hide home schooling section
      $('.home_schooling_content').slideToggle 'slow'

    $('.show_location_schooling_content').on 'click',  -> #show hide locations schooling section
      $('.location_schooling_content').slideToggle 'slow'

    $('.show_maps_content').on 'click', -> #show hide locations section
      $('#map_container').slideToggle 'slow', -> #run function when slideToggle has finished
        business_page_ready() #initialise maps when slideToggle has finshed loading

#end of  teachers business page, add subject name to for before submitting

#teacher edit page

  if $('.teacher_edit_profile')

    $('.show_edit_teacher_info_content').on 'click',  ->
      $('.edit_teacher_info_content').slideToggle 'slow'

    $('.show_edit_teacher_subjects_content').on 'click', ->
      $('.edit_teacher_subjects_content').slideToggle 'slow'

    $('.show_edit_teacher_photos_content').on 'click',  ->
      $('.edit_teacher_photos_content').slideToggle 'slow'

    $('.show_edit_teacher_experience_content').on 'click',  ->
      $('.edit_teacher_experience_content').slideToggle 'slow'

    $('.show_edit_teacher_bio_content').on 'click',  ->
      $('.edit_teacher_bio_content').slideToggle 'slow'

    $('.show_edit_teacher_payment_content').on 'click',  ->
      $('.edit_teacher_payment_content').slideToggle 'slow'




$(document).on('ready', teachersInfoReady)
$(document).on('page:load', teachersInfoReady)
$(window).unload(teachersInfoReady)

getCounties = () ->
  return ['Antrim','Armagh','Carlow','Cavan','Clare','Cork','Derry','Donegal','Down','Dublin',
          'Fermanagh','Galway','Kerry','Kildare','Kilkenny','Laois','Leitrim','Limerick','Longford',
          'Louth','Mayo','Meath','Monaghan','Offaly','Roscommon','Sligo','Tipperary','Tyrone',
          'Waterford','Westmeath','Wexford','Wicklow']