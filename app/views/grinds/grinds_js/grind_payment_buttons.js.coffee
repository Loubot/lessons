$('.grind_payment_form_container').html """
    <div class="col-xs-6">
      <% if @teacher.paypal_email != "" %>
        <%= form_tag grind_paypal_path, class: 'form-horizontal', method: 'post' do |f| %>
          <%= hidden_field_tag :grind_id, @grind.id %>
          <%= hidden_field_tag :cart_id, @cart.id %>
          <%= image_submit_tag 'https://www.paypalobjects.com/en_US/i/btn/x-click-but6.gif', class: 'img-responsive' %>
        <% end %> <%# end of form %>
      <% end %> <%# end of teacher.paypal_email %>
    </div> <!-- end of col-xs-6 -->


    <div class="col-xs-6">
      <% if @teacher.stripe_access_token != "" %>
        <%= form_tag grind_stripe_path, class: 'form-horizontal package_booking_form', method: 'post' do |f| %>
          <script src="https://checkout.stripe.com/checkout.js" class="stripe-button"
                data-key="pk_test_bedFzS7vnmzthkrQolmUjXNn"
                data-description="Book your lesson"
                data-currency="eur"
                data-description="This is the description"
                data-imgage="<%= asset_url 'stripe.png' %>"
                ></script>
          <%= hidden_field_tag :grind_id, @grind.id %>
          <%= hidden_field_tag :cart_id, @cart.id %>
        <% end %> <%# end of form %>
      <% end %>
    </div> <!-- end of col-xs-6 -->
  
"""