class PaymentsController < ApplicationController

  def paypal_create
    create_paypal(params) if params[:paypal].present?
  end


  def stripe_create
   # Amount in cents
    @amount = params[:amount].to_i * 100    

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

    redirect_to welcome_path

    rescue Stripe::CardError => e
      flash[:error] = e.message
      redirect_to charges_path
    end
  end




  private

      def create_paypal(params)
        require "pp-adaptive"
        client = AdaptivePayments::Client.new(
          :user_id       => "lllouis_api1.yahoo.com",
          :password      => "MRXUGXEXHYX7JGHH",
          :signature     => "AFcWxV21C7fd0v3bYYYRCpSSRl31Akm0pm37C5ZCuhi7YDnTxAVFtuug",
          :app_id        => "APP-80W284485P519543T",
          :sandbox       => true
        )

        client.execute(:Pay,
          :action_type     => "PAY",
          :receiver_amount => params[:receiver_amount],
          :currency_code   => "GBP",
          :cancel_url      => "https://learn-your-lesson.herokuapp.com",
          :return_url      => "https://learn-your-lesson.herokuapp.com/paypal-return",
          :notify_URL      => 'https://learn-your-lesson.herokuapp.com/store-paypal',
          :ipn_notification_url => "https://learn-your-lesson.herokuapp.com/store-paypal",
          :receivers       => [
            { :email => 'louisangelini@gmail.com', :amount => 50, :primary => true },
            { :email => 'loubotsjobs@gmail.com', :amount => 35 }
            ] 
          
        ) do |response|

          if response.success?
            puts "Pay key: #{response.pay_key}"

            # send the user to PayPal to make the payment
            # e.g. https://www.sandbox.paypal.com/webscr?cmd=_ap-payment&paykey=abc
            redirect_to client.payment_url(response)
          else
            puts "#{response.ack_code}: #{response.error_message}"
          end
               
      end

end
