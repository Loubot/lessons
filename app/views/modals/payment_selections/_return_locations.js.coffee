$('.returned_locations_container').empty()
$('.returned_locations_container').append """
                                          <%= select_tag 'subjects',  options_from_collection_for_select(@locations, 'id', 'name'), { class: 'form-control'} %>
  

                                        """