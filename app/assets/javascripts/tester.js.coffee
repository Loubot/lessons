initialise_refresh = ->
  $(document).on 'click', '.browse_option', (e) ->

    $.ajax
      url: 'refresh-welcome'
      data: { page: $(@).attr('id') }
      type: 'get'
      success: (html) ->
        h = $('#main_page').height()
        
        $('.stock_photos_container').empty()
        $('#main_page').height(868)
        $(html).appendTo('.stock_photos_container').show('slow')
        
    e.preventDefault()
    return false
        
        









$(document).on 'ready page:load', ->
  if $('#main_subject_search').length > 0
    initialise_refresh()