class PaymentsController < ApplicationController

  protect_from_forgery except: [:store_paypal, :store_stripe, :stripe_create]
  before_action get_event_id, only: [store_paypal:, store_stripe:]


  def get_event_id
    @event_id = session[:event_params] || []
  end

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

    # customer = Stripe::Customer.create(
    #   :email => 'lllouis@yahoo.com',
    #   :card  => params[:stripeToken]
    # )

    charge = Stripe::Charge.create({
      :amount      => @amount,
      :description => "{}",
      :currency    => 'eur',
      :application_fee => 3300,
      :card => params[:stripeToken]
      },
      Teacher.find(params[:teacher_id]).stripe_access_token
    )

    redirect_to welcome_path

    rescue Stripe::CardError => e
      flash[:error] = e.message
      redirect_to charges_path
    
  end

  def store_stripe
    require 'json'
    json_response = JSON.parse(request.body.read)
    p "%%%%%%%%%%%%%%%%% #{json_response['data']['object']['id']}"
    render status: 200, nothing: true
  end

  def stripe_auth_user
    uri = URI.parse('https://connect.stripe.com/oauth/token')
    uri.query = URI.encode_www_form({
        'client_secret' => 'sk_test_1ZTmwrLuejFto5JhzCS9UAWu', 'code' => params[:code],
          'grant_type' => 'authorization_code'
      })
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    request = Net::HTTP::Post.new(uri.request_uri)
    response = http.request(request).body
    json_resp = JSON.parse(response)

    p "££££££££££££££££££££££ #{json_resp}"
    # params = {'client_secret' => 'sk_test_1ZTmwrLuejFto5JhzCS9UAWu', 'code' => 'ac_4qftwDWUN15L3DvnQIp0XxT7nXrKEX5Q',
    #   'grant_type' => 'authorization_code'}
    
    # conn = Net::HTTP.new("https://connect.stripe.com/oauth/token")
    # r = conn.post('/oauth/token', params)
    # p "(((((((((((((((((((( #{r}"
    if json_resp['access_token'].present?
      @teacher = Teacher.find(current_teacher.id)
      flash[:success] = "Successfully registered with Stripe"
      @teacher.update_attributes(stripe_access_token: json_resp['access_token'])
    end
    redirect_to edit_teacher_path(id: params[:state])
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
          :currency_code   => "GBP",
          :cancel_url      => "https://learn-your-lesson.herokuapp.com",
          :return_url      => "http://learn-your-lesson.herokuapp.com/paypal-return",
          :notify_URL      => 'http://10c416a6.ngrok.com/store-paypal',
          :ipn_notification_url => 'http://learn-your-lesson.herokuapp.com/store-paypal',
          :receivers => [
            { :email => 'louisangelini@gmail.com', amount: params[:receiver_amount], primary: true },
            { :email => 'loubotsjobs@gmail.com',  amount: 10}
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

end


# authorisation code ac_4qQhjRNlu4BQ0UCRpwg1kGBqC3r3RKdH


# curl -X POST https://connect.stripe.com/oauth/token \
#   -d client_secret=sk_test_1ZTmwrLuejFto5JhzCS9UAWu \
#   -d code=ac_4qg3IUs0PsYCNwhxcLI8d66VkslSgj7U \
#   -d grant_type=authorization_code