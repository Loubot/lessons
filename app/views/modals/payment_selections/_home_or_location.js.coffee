$('.returned_locations_container').empty()
$('.returned_locations_container').append """ 
    <%= select 'location', 'id', options_for_select([['Home lesson', 1], ['Teachers house', '2']]), { include_blank: true }, { class: 'form-control select_home_or_location'} %>

                                    """