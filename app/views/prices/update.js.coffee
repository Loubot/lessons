if $('.price_alert_message').length
	$('.price_alert').prepend """ <p class="price_alert_message"> <%= @name %> price updated </p> """
	$('.price_alert').css 'visibility', 'visible'
	<%= puts "price #{@name}" %>

	setTimeout (->
		  $(".price_alert").css 'visibility', 'hidden'
		  $(".price_alert").empty()
		  return
		), 5000


