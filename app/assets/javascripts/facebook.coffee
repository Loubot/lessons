fb_root = null
fb_events_bound = false

$ ->
  loadFacebookSDK()
  bindFacebookEvents() unless fb_events_bound

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

loadFacebookSDK = ->
  fbScript = document.createElement('script')
  fbScript.type = "text/javascript"
  # window.fbAsyncInit = initializeFacebookSDK
  fbScript.src = ("//connect.facebook.net/en_US/all.js#xfbml=1" + "callback=initializeFacebookSDK")
  document.body.appendChild fbScript

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
      left: 0
      height: 70
   
    return


twttr_events_bound = false

$ ->
  loadTwitterSDK()
  bindTwitterEventHandlers() unless twttr_events_bound

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
