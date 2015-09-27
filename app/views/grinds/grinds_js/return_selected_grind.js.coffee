$('.selected_grind_container').html """
  <%= form_tag check_and_start_payment_grind_path(id: @grind.id), html: { class: 'form-horizontal' }, method: 'post',\
         remote: true do %>

    <div class="row">
      <div class="col-md-12">
        <%= text_field_tag 'number_left', "#{ @grind.number_left } place(s) left", class: 'form-control', disabled: true %>
      </div> <!-- end of col-md-12 -->
    
    
      <div class="col-md-6">
        Number of places?
      </div> <!-- end of col-md-6 -->
      <div class="col-md-6">
        <%= number_field_tag 'quantity', nil, max: @grind.number_left, class: 'form-control', prompt: 'How many places?' %>
      </div><!-- end of col-md-6 -->

      <div class="form-group">
        <div class="col-sm-offset-2 col-sm-10">
          <%= submit_tag "Let's go", class: 'btn btn-success' %>
        </div> <!-- end of col-sm-offset-2 col-sm-10 -->
      </div> <!-- end of form-group -->

    </div> <!-- end of row -->
  <% end %> 
"""