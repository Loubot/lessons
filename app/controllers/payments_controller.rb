class PaymentsController < ApplicationController

  protect_from_forgery except: [:store_paypal]

  def paypal_create
    create_paypal(params) if params[:paypal].present?
  end

  def store_paypal
    p "???????????????? #{params.inspect}"
    uri = URI.parse('https://www.sandbox.paypal.com/cgi-bin/webscr?cmd=_notify-validate')
    http = Net::HTTP.new(uri.host,uri.port)
    http.open_timeout = 60
    http.read_timeout = 60
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    http.use_ssl = true
    response = http.post(uri.request_uri, request.raw_post, 'Content-Length' => "#{request.raw_post.size}",
                          'User-Agent' => 'My custom user agent').body
    puts "*************** #{response}"
    render nothing: true
  end

  def paypal_return
    
    require "pp-adaptive"

    client = AdaptivePayments::Client.new(
      :user_id       => "lllouis_api1.yahoo.com",
      :password      => "MRXUGXEXHYX7JGHH",
      :signature     => "AFcWxV21C7fd0v3bYYYRCpSSRl31Akm0pm37C5ZCuhi7YDnTxAVFtuug",
      :app_id        => "APP-80W284485P519543T",
      :sandbox       => true
    )

    client.execute(:PaymentDetails, :pay_key => "AP-4TS489127N381100H") do |response|
      if response.success?
        puts "Payment status: #{response.inspect}"
        flash[:success] = "Payment status: #{response.inspect}"
      else
        puts "#{response.ack_code}: #{response.error_message}"
      end
    end

    redirect_to root_url
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

  def store_paypal
    # https://stripe.com/docs/webhooks
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
