# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$(document).on 'page:change', ->
	$('a[href="' + this.location.pathname + '"]').parent().addClass('active')


	# $('#doit').click (e) ->
	# 	e.preventDefault()
	# 	$.ajax
	# 		url: 'http://us8.api.mailchimp.com/1.3/'
	# 		apikey: 'a54fa2423a373c73c8eff5e2f8c208d4-us8'
	# 		id: 'e854603460'
	# 		double_optin: true
	# 		email: $('#email').val()
	# 		success: (json) ->
	# 			alert JSON.stringify json
	# 		error: (error) ->
	# 			alert JSON.stringify error