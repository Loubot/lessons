fb_root = null
fb_events_bound = false

loadFacebookSDK = ->
  window.fbAsyncInit = initializeFacebookSDK
  $.getScript("//connect.facebook.net/en_US/all.js#xfbml=1")

bindFacebookEvents = ->
  $(document)
    .on('page:fetch', saveFacebookRoot)
    .on('page:change', restoreFacebookRoot)
    .on('page:load', ->
      FB?.XFBML.parse()
    )
  fb_events_bound = true







saveFacebookRoot = ->
  fb_root = $('#fb-root').detach()

restoreFacebookRoot = ->
  if $('#fb-root').length > 0
    $('#fb-root').replaceWith fb_root
  else
    $('body').append fb_root




initializeFacebookSDK = ->
  FB.init
    appId     : '734492879977460'
    channelUrl: '//learn-your-lesson.heroku.com/'
    status    : true
    cookie    : true
    xfbml     : true
  FB.Event.subscribe "edge.create", (href, widget) ->
    $('#share_buttons').animate
      top: 53
      left: 350
      height: 70
   
    return

# twitter starts here


twttr_events_bound = false



bindTwitterEventHandlers = ->
  $(document).on 'page:load', renderTweetButtons
  twttr_events_bound = true

renderTweetButtons = ->
  $('.twitter-share-button').each ->
    button = $(this)
    button.attr('data-url', document.location.href) unless button.data('url')?
    button.attr('data-text', document.title) unless button.data('text')?
  twttr.widgets.load()

loadTwitterSDK = ->
  twitterScript = document.createElement 'script'
  twitterScript.type = "text/javascript"
  twitterScript.src = "//platform.twitter.com/widgets.js"
  # $.getScript("//platform.twitter.com/widgets.js")
  document.body.appendChild twitterScript

  

loadSocials = ->
  if(jQuery.cookieBar('cookies'))  #jquery cookie bar for eu law

    loadTwitterSDK()
    bindTwitterEventHandlers() unless twttr_events_bound

    loadFacebookSDK()
    bindFacebookEvents() unless fb_events_bound
    

  Loader = ->

  Loader.prototype =
    require: (scripts, callback) ->
      @loadCount = 0
      @totalRequired = scripts.length
      @callback = callback
      i = 0
      while i < scripts.length
        @writeScript scripts[i]
        i++
      return
    loaded: (evt) ->
      @loadCount++
      if @loadCount == @totalRequired and typeof @callback == 'function'
        @callback.call()
      return
    writeScript: (src) ->
      self = this
      s = document.createElement('script')
      s.type = 'text/javascript'
      s.async = true
      s.src = src
      s.addEventListener 'load', ((e) ->
        self.loaded e
        return
      ), false
      head = document.getElementsByTagName('head')[0]
      head.appendChild s
      return

  l = new Loader
  l.require [
    'https://platform.linkedin.com/in.js?async=true'
  ], ->
    IN.init({api_key:'77iyb2qd8pdh8f'})
    console.log 'All Scripts Loaded'
    return

 

$(document).ready loadSocials
$(document).on 'page:load', loadSocials

