class PaymentsController < ApplicationController

  def stripe_create
   # Amount in cents
    @amount = 500

    customer = Stripe::Customer.create(
      :email => 'lllouis@yahoo.com',
      :card  => params[:stripeToken]
    )

    charge = Stripe::Charge.create(
      :customer    => customer.id,
      :amount      => @amount,
      :description => 'Rails Stripe customer',
      :currency    => 'eur'
    )

    rescue Stripe::CardError => e
      flash[:error] = e.message
      redirect_to charges_path
    end
end
