$('.nav.nav-tabs').append """ <li role="presentation"  class="location_tab"><a href="#meballs" id="location_tab" aria-controls="settings" role="tab" data-toggle="tab">Enter Address</a></li> """
$('.tab-content').append """ <div role="tabpanel" class="tab-pane" id="meballs">
  <div class="col-md-8 nopadding">     
    <div id="map_canvas<%= @id %>" class="col-md-12 map_canvas" ></div>
    </div> <!-- end of col-md-8 -->
    <div class="col-md-4" >
      <h2 class="h3">Where are you located?</h2><br>
      <input id="address<%= @id %>" type="text"><button id="start_address_search" onclick="start_address_search(<%= @id %>)">Find address</button><br>
      <h4>Or click on the map</h4><br>
      <%= form_for [@teacher, @location], html: { class: 'form-horizontal'} do |f| %>
        <div class="form-group">
          <%= f.label :name, class: 'col-sm-2 control-label' %>
          <div class="col-sm-10">
            <%= f.text_field :name, class: 'form-control', id: 'lat' %>
          </div>
        </div> <!-- end of form-group -->
        <div class="form-group">
          <%= f.label :latitude, class: 'col-sm-2' %>
          <div class="col-sm-10">
            <%= f.text_field :latitude, class: 'form-control', id: "lat#{@id}" %>
          </div>
        </div> <!-- end of form-group -->
        <div class="form-group">
          <%= f.label :longitude, class: 'col-sm-2' %>
          <div class="col-sm-10">
            <%= f.text_field :longitude, class: 'form-control', id: "lon#{@id}" %>
          </div>
        </div> <!-- end of form-group -->
        
        <div class="col-sm-offset-2 col-sm-10">
          <%= f.submit 'Add this location', class: 'btn btn-info' %>
        </div>
        <%= f.hidden_field :teacher_id, value: current_teacher.id %>
      <% end %>
      <p class="text-center coordsHinter">No coordinates selected yet!!</p>
    </div> <!-- end of col-md-4 -->
      <script>
        window.initialize(<%= @id %>)

      </script>
  </div> """