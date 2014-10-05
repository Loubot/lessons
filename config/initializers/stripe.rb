Rails.configuration.stripe = {
  :publishable_key => 'pk_test_bedFzS7vnmzthkrQolmUjXNn',
  :secret_key      => 'sk_test_1ZTmwrLuejFto5JhzCS9UAWu'
}

Stripe.api_key = Rails.configuration.stripe[:secret_key]