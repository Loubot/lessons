$('.returned_locations_container').empty()
$('.payment_form_container').empty()
$('.returned_locations_container').append """ 
    <%= select 'location', 'id', options_for_select([['teachers house or yours?....'],['Home lesson', 1], ['Teachers house', '2']]), {  }, { class: 'form-control select_home_or_location'} %>

                                    """