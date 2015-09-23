$('.display_grind_user').html """
  <div class="row">
    <% @teacher.grinds.each do |g| %>
      <div class="well grind_well col-md-6 col-xs-12">
        <h4>Subject: <%= g.subject_name %></h4>
        <%= form_tag check_grind_availability_grind_path(id:params[:id]), html: { class: 'form-horizontal grind_form' } do %>

          <div class="form-group">
            <%= label_tag :subject_id, 'Subject?', class: 'well_form_label col-sm-3 control-label' %>
            <div class="col-sm-9">
              <%= text_field_tag :subject, @subject.name, disabled: true, class: 'form-control' %>
            </div> <!-- end of col-sm-10 -->
          </div> <!-- end of form-group -->

          <div class="form-group">
            <label  class="col-sm-3 control-label">Start time:</label>
            <div class="col-sm-9">
              <span class="form-control"><%= g.start_time.strftime("%a %b %Y %H:%M%p") %></span>
            </div>  <!-- end of col-sm-10 -->
          </div> <!-- end of form-group -->  

          <div class="form-group">
            <label  class="col-sm-3 control-label">Places left</label>
            <div class="col-sm-9">
              <%= number_field_tag 'number_left', (g.capacity - g.number_booked), class: 'form-control', disabled: true %>
            </div>  <!-- end of col-sm-10 -->
          </div> <!-- end of form-group -->

          <div class="form-group">
            <label  class="col-sm-3 control-label">Price €</label>
            <div class="col-sm-9">
              <%= number_field_tag 'price', number_with_precision(g.price, precision: 2), class: 'form-control', disabled: true %>
            </div>  <!-- end of col-sm-10 -->
          </div> <!-- end of form-group -->

          <div class="form-group">
            <label  class="col-sm-3 control-label">Location</label>
            <div class="col-sm-9">
              <%= text_field_tag 'Location_name', @teacher.locations.find(g.location_id).name, class: 'form-control', disabled: true %>
            </div>  <!-- end of col-sm-10 -->
          </div> <!-- end of form-group -->

          <div class="form-group">
            <div class="col-sm-offset-2 col-sm-10">
              <%= submit_tag 'Create', class: 'btn btn-success' %>
            </div> <!-- col-sm-offset-2 col-sm-10 -->
          </div> <!-- end of form-group --> 

        <% end %>
      </div> <!-- end of col-md-6 col-xs-12 -->
    <% end %>

  </div>  <!-- end of row -->

"""

