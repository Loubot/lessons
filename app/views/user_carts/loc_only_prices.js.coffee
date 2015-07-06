$('.location_only_price_select').html """
  <%= j(options_for_select(@prices.map { |p| \
    ["#{p.duration} mins #{number_to_currency(p.price, unit:'€')}", p.id] })) %>
"""

$('.location_only_price_select').css 'display', 'inline'
$('.home_only_avail_times').css 'display', 'inline'