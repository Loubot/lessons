$('.nav.nav-tabs').append """ <li role="presentation"><a href="#meballs" aria-controls="settings" role="tab" data-toggle="tab">meballs</a></li> """
$('.tab-content').append """ <div role="tabpanel" class="tab-pane" id="meballs">
  <div class="col-md-8">  
    <p> <%= puts @id %> </p>    
    <div id="map_canvas<%= @id %>" class="col-md-12 map_canvas" ></div>
    </div> <!-- end of col-md-8 -->
    <div class="col-md-4" >
      <h2 class="h3">Where are you located?</h2><br>
      <input id="address<%= @id %>" type="text"><button id="start_address_search" onclick="start_address_search(<%= @id %>)">Find address</button><br>
      <h4>Or click on the map</h4><br>
      <%= form_for @location, html: { class: 'form-horizontal'} do |f| %>
        <div class="form-group">
          <%= f.label :latitude, class: 'col-sm-2' %>
          <div class="col-sm-10">
            <%= f.text_field :latitude, class: 'form-control', id: 'lat' %>
          </div>
        </div> <!-- end of form-group -->
        <div class="form-group">
          <%= f.label :longitude, class: 'col-sm-2' %>
          <div class="col-sm-10">
            <%= f.text_field :longitude, class: 'form-control', id: 'lon' %>
          </div>
        </div>
        <div class="col-sm-offset-2 col-sm-10">
          <%= f.submit 'Update your coordinates', class: 'btn btn-info' %>
        </div>
      <% end %>
      <p class="text-center coordsHinter">No coordinates selected yet!!</p>
    </div> <!-- end of col-md-4 -->
      <script>
        window.initialize(<%= @id %>)

      </script>
  </div> """