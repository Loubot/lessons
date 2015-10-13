$('.grind_payment_modal_container').html """
  j(<div class="modal fade" id="grind_payment_modal" tabindex="-7" role="dialog" aria-labelledby="grind_payment_label">
      <div class="modal-dialog" role="document">
        <div class="modal-content">
  
          <div class="modal-header">
            <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
            <h4 class="modal-title">
              Grinds payment
            </h4> <!-- end of modal-title -->
          </div> <!-- end of modal-header -->
  
          <div class="modal-body">
            <table class="table table-bordered">
  
              <thead>
                <tr>
                  <th>Subject:</th>
                  <th><%= @grind.subject_name %></th>                
                </tr>
              </thead>
  
              <tbody>
                <tr>
                  <td>Places left:</td>
                  <td><%= @grind.number_left %>
                </tr>
  
                <tr>
                  <td>Price per place:</td>
                  <td><%= number_to_currency(@grind.price, unit: '€') %>
                </tr>
  
                <tr>
                  <td>Time</td>
                  <td><%= @grind.start_date.strftime('%e/%b/%y %I:%M%p') %>
                </tr>
  
              </tbody>
            </table> <!-- end of table-bordered -->
  
            <%= form_tag check_booking_grind_path(id: @grind.id), remote: true, class: 'form-horizontal' do %>
              <div class="form-group">
                <div class="col-sm-2 control-label">Places?</div> <!-- end of col-sm-2 control-label -->
                <div class="col-sm-10">
                  <%= number_field_tag 'quantity', step: 1, in: 1...@grind.number_left %>
                </div> <!-- end of col-sm-10 -->
              </div>
              
  
              <div class="form-group">
                <div class="col-sm-offset-2 col-sm-10">
                  <%= submit_tag 'Check', class: 'btn btn-info' %>
                </div> <!-- end of col-sm-offset-2 col-sm-10 -->
              </div> <!-- end of form-group -->
              <%= hidden_field_tag 'grind_id', @grind.id %>
            <% end %>

            <div class="grind_payment_form_container row">

            </div> <!-- end of grind_payment_form_container -->

          </div> <!-- end of modal-body -->
  
          <div class="modal-footer">
            <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
          </div> <!-- end of modal-footer -->
        </div> <!-- end of modal-content -->
      </div> <!-- end of modal-dialog -->
    </div> <!-- end of grind_payment_modal -->)

"""

$('#grind_payment_modal').modal('show')
$('.tooltip').remove()
$('.dhx_cal_cover').remove()