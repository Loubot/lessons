$('.returned_grinds_container').html """

  <%= select_tag "grinds[selection]", options_for_select(get_select_text_for_grinds(@grinds)) , \
                                            class: 'form-control grind_payment_select_grind',\
                                             prompt: 'Select your grind' %>

"""


