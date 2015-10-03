$('.grind_payment_modal_container').html """
  <div class="modal fade" id="grind_payment_modal" tabindex="-3" role="dialog" aria-labelledby="grind_payment_label">
    <div class="modal-dialog" role="document">
      <div class="modal-content">

        <div class="modal-header">
          <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
          <h4 class="modal-title">
            Grinds payment
          </h4> <!-- end of modal-title -->
        </div> <!-- end of modal-header -->

        <div class="modal-body">
          <%= @grind.subject_name %>
        </div> <!-- end of modal-body -->

        <div class="modal-footer">
          <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
        </div> <!-- end of modal-footer -->
      </div> <!-- end of modal-content -->
    </div> <!-- end of modal-dialog -->
  </div> <!-- end of grind_payment_modal -->

"""

$('#grind_payment_modal').modal('show')