class PaymentsController < ApplicationController

  include PaymentsHelper

  protect_from_forgery except: [:store_paypal, :store_stripe, :stripe_create, :stripe_auth_user]
  before_action :get_event_id, only: [:store_paypal, :store_stripe]

  before_action :fix_json_params, only: [:store_stripe]


  def get_event_id
    @event_id = session[:event_params] || []
  end

  def paypal_create    
    create_paypal(params) if params[:paypal].present?
  end
  
  
  def store_paypal
    
    uri = URI.parse('https://www.sandbox.paypal.com/cgi-bin/webscr?cmd=_notify-validate')
    http = Net::HTTP.new(uri.host,uri.port)
    http.open_timeout = 60
    http.read_timeout = 60
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    http.use_ssl = true
    response = http.post(uri.request_uri, request.raw_post, 'Content-Length' => "#{request.raw_post.size}",
                          'User-Agent' => 'My custom user agent').body
    p "paypal post params: #{params['tracking_id']}"
   
    puts "Paypal verification response: #{response}"
    logger.info "Paypal verification response: #{response}"
    transaction = Transaction.find_by(tracking_id: params['tracking_id'])
    
    if transaction == nil
      if response == "VERIFIED"
        cart = UserCart.find_by(tracking_id: params['tracking_id'])
        render status: 200, nothing: true and return if !cart
        event = Event.create!(cart.params)
        logger.info "teacher #{event.teacher_id}, student #{event.student_id}"
        logger.info "returned params #{create_transaction_params_paypal(params, event.student_id, event.teacher_id)}"
        transaction = Transaction.create!(create_transaction_params_paypal(params, event.student_id, event.teacher_id))
        p "Event errors #{event.errors.full_messages}" if !event.valid?
        p "Event created id: #{event.id}"
        TeacherMailer.test_mail(cart.student_email,cart.student_name,cart.teacher_email, event.start_time, event.end_time)
        render status: 200, nothing: true
      else
        p "Paypal payment didn't work out"
        render status: 200, nothing: true
      end
    elsif transaction
      render status: 200, nothing: true
    else
      logger.info "MAJOR ALERT: Transaction not found"
    end

  end

  def paypal_return
    puts "paypal return params paykey: #{params[:payKey]}"
    require "pp-adaptive"

    client = AdaptivePayments::Client.new(
      :user_id       => "lllouis_api1.yahoo.com",
      :password      => "MRXUGXEXHYX7JGHH",
      :signature     => "AFcWxV21C7fd0v3bYYYRCpSSRl31Akm0pm37C5ZCuhi7YDnTxAVFtuug",
      :app_id        => "APP-80W284485P519543T",
      :sandbox       => true
    )

    client.execute(:PaymentDetails, :pay_key => params[:payKey]) do |response|
      if response.success?
        puts "Payment status: #{response.inspect}"
        flash[:success] = "Payment was successful. You will receive an email soon. Eventually. When I code it!"
      else
        puts "#{response.ack_code}: #{response.error_message}"
        flash[:danger] = "Payment failed"
      end
    end

    
    redirect_to root_url
  end


  def stripe_create
   # Amount in cents
    puts 'whoop whoop'
    @amount = params[:amount].to_i * 100    

    charge = Stripe::Charge.create({
      :amount             => @amount,
      :description        => "{}",
      :currency           => 'eur',
      :application_fee    => 300,
      :card               => params[:stripeToken],
      :metadata           => { tracking_id: params[:tracking_id] }
      },
      Teacher.find(params[:teacher_id]).stripe_access_token
    )
    if charge['paid'] == true
      cart = UserCart.find_by(tracking_id: charge['metadata']['tracking_id'])
      event = Event.create!(cart.params)
      puts "Stripe successful event created id: #{event.id}"
    end
    flash[:success] = 'Payment was successful. You will receive an email soon. Eventually. When I code it!'
    redirect_to root_url

    rescue Stripe::CardError => e
      flash[:error] = e.message
      redirect_to charges_path
    
  end

  def store_stripe
    
    json_response = JSON.parse(request.body.read)

    render status: 200, nothing: true and return if json_response['type'] == "application_fee.created"

    logger.info "Stripe webhook response: #{json_response}"
    logger.info "Store-stripe params #{json_response['data']['object']['metadata']['tracking_id']}"
    
    if !(Transaction.find_by(tracking_id: json_response['data']['object']['metadata']['tracking_id']))
      cart = UserCart.find_by(tracking_id: json_response['data']['object']['metadata']['tracking_id'])
      render status: 200, nothing: true and return if !cart
      cart_params = cart.params
      puts "cart params #{cart_params}"
      puts "start time #{cart_params[:start_time]}"
 
      
      TeacherMailer.test_mail(cart.student_email,cart.student_name,cart.teacher_email,
                              cart_params[:start_time],cart_params[:end_time])
      Transaction.create!(create_transaction_params_stripe(json_response, cart.student_id, cart.teacher_id))
      # Transaction.create!(json_response)
      render status: 200, nothing: true
    else
      render status: 200, nothing: true
    end   
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

    p "Stripe authorise user response: #{json_resp}"
    # params = {'client_secret' => 'sk_test_1ZTmwrLuejFto5JhzCS9UAWu', 'code' => 'ac_4qftwDWUN15L3DvnQIp0XxT7nXrKEX5Q',
    #   'grant_type' => 'authorization_code'}
    
    # conn = Net::HTTP.new("https://connect.stripe.com/oauth/token")
    # r = conn.post('/oauth/token', params)
    # p "(((((((((((((((((((( #{r}"
    if json_resp['access_token'].present?
      @teacher = Teacher.find(params['state'].to_i)
      flash[:success] = "Successfully registered with Stripe"
      @teacher.update_attributes(stripe_access_token: json_resp['access_token'])
    end
    flash[:success] = 'Stripe code updated'
    redirect_to edit_teacher_path(id: params[:state])
  end


  

  

  


  private
  def params
    @reparsed_params || super
  end

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
          :tracking_id     => params[:tracking_id],
          :cancel_url      => "https://learn-your-lesson.herokuapp.com",
          :return_url      => "http://771852a9.ngrok.com/paypal-return?payKey=${payKey}",
          :ipn_notification_url => 'http://771852a9.ngrok.com/store-paypal',
          :receivers => [
            { :email => params[:teacher], amount: params[:receiver_amount], primary: true },
            { :email => 'loubotsjobs@gmail.com',  amount: 10 }
          ]
        ) do |response|

          if response.success?
            puts "Pay key: #{response.pay_key}"
            logger.info "create paypal response #{response.inspect}"

            # send the user to PayPal to make the payment
            # e.g. https://www.sandbox.paypal.com/webscr?cmd=_ap-payment&paykey=abc
            redirect_to client.payment_url(response)
          else
            flash[:danger] = "#{response.error_message}"
            puts "Paypal error message: #{response.ack_code}: #{response.error_message}"
            redirect_to :back
          end

        end
        
      end

      protected

        def fix_json_params
          if request.content_type == "application/json"
            @reparsed_params = JSON.parse(request.body.string).with_indifferent_access
          end
        end
end