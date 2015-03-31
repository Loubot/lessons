class PaypalController < ApplicationController

  include PaymentsHelper
  before_action :authenticate_teacher!, only: [:paypal_create, :single_booking_paypal]
  protect_from_forgery except: [:store_paypal, :store_stripe, :stripe_create, :stripe_auth_user]
  before_action :get_event_id, only: [:store_paypal, :store_stripe]

  # before_action :fix_json_params, only: [:store_stripe]


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
    response = http.post(
                          uri.request_uri, 
                          request.raw_post, 
                          'Content-Length' => "#{request.raw_post.size}",
                          'User-Agent' => 'My custom user agent'
                        ).body

    p "paypal post params: #{params['tracking_id']}"
   
    puts "Paypal verification response: #{response}"
    logger.info "Paypal verification response: #{response}"
    
    
    if !(Transaction.find_by(tracking_id: params['tracking_id']))
      if response == "VERIFIED"
        cart = UserCart.find_by(tracking_id: params['tracking_id'])

        render status: 200, nothing: true and return if !cart


        # logger.info "teacher #{event.teacher_id}, student #{event.student_id}"
        logger.info "returned params #{create_transaction_params_paypal(params, cart.student_id, cart.teacher_id)}"

        Event.create_confirmed_events(cart)

        transaction = Transaction.create( #payments_helper
                                          create_transaction_params_paypal(params, cart.student_id, cart.teacher_id)
                                        )

        # p "Event errors #{event.errors.full_messages}" if !event.valid?
        # p "Event created id: #{event.id}"
        TeacherMailer.mail_teacher(
                                    cart.student_email,
                                    cart.student_name,
                                    cart.teacher_email,
                                    cart.params[:start_time],
                                    cart.params[:end_time]
                                  ).deliver_now

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


  def home_booking_paypal
    p "params %%%%%%%%%%%%%%%%% #{params}"
    current_teacher.update_attributes(address: params[:home_address])
    redirect_to :back and return
    cart = UserCart.home_booking_cart(params)
    p cart.home_booking
    p "cart $$$$$$$$$$$$$$$$$$$$$ #{cart.inspect}"
    # render status: 200, nothing: true
    
    
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
      :tracking_id     => cart.tracking_id,
      :cancel_url      => "https://learn-your-lesson.herokuapp.com",
      :return_url      => "https://learn-your-lesson.herokuapp.com/paypal-return?payKey=${payKey}",
      :ipn_notification_url => 'http://6659c9f3.ngrok.com/store-paypal',
      :receivers => [
        { :email => params[:teacher_email], amount: params[:receiver_amount], primary: true },
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
          :return_url      => "https://learn-your-lesson.herokuapp.com/paypal-return?payKey=${payKey}",
          :ipn_notification_url => 'https://learn-your-lesson.herokuapp.com/store-paypal',
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

      
end