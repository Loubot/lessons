$('.returned_levels_container').html """

   <%= select_tag "grinds[selection]", options_for_select(get_level_select(@levels)) , \
                                            class: 'form-control grind_select_level',\
                                             prompt: 'Select level' %>

"""