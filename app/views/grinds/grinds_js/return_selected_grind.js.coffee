$('.selected_grind_container').html """
  
  <%= text_field_tag 'number_left', "#{ @grind.number_left } place(s) left", class: 'form-control', disabled: true %>
  
  <%= number_field_tag 'quantity', nil, max: @grind.number_left, class: 'form-control', prompt: 'How many places?' %>
    
  

"""