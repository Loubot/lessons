class PaypalController < ApplicationController

  include PaymentsHelper
  before_action :authenticate_teacher!, only: [
                                                :paypal_create,
                                                :home_booking_paypal, 
                                                :single_booking_paypal,
                                                :create_package_booking, 
                                                :pay_membership_paypal
                                              ]
  protect_from_forgery except: [:store_paypal, :store_package_paypal, :membership_return_paypal]
  before_action :get_event_id, only: [:store_paypal]

  # before_action :fix_json_params, only: [:store_stripe]


  def get_event_id
    @event_id = session[:event_params] || []
  end

  def paypal_create
    p "got here"
    create_paypal(params)
  end

  #handle membership payments

  def pay_membership_paypal
    cart = UserCart.membership_cart(current_teacher.id, current_teacher.email)
    client = AdaptivePayments::Client.new(
      :user_id       => ENV['PAYPAL_USER_ID'],
      :password      => ENV['PAYPAL_PASSWORD'],
      :signature     => ENV['PAYPAL_SIGNATURE'],
      :app_id        => ENV['PAYPAL_APP_ID'],
      sandbox:       true
      
    )

    client.execute(:Pay,
      :action_type     => "PAY",
      :receiver_email  => "lllouis@yahoo.com",
      :receiver_amount => 3,
      :tracking_id     => cart.tracking_id,
      :currency_code   => "EUR",
      :cancel_url      => "https://www.learnyourlesson.ie",
      :return_url      => "https://wwww.learnyourlesson.ie/welcome",
      :ipn_notification_url => "https://wwww.learnyourlesson.ie/membership-return-paypal"
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

  def membership_return_paypal
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

   p "status #{params['status']}"

    if !(transaction = Transaction.find_by(tracking_id: params['tracking_id'])) && (params['status'] == 'COMPLETED')
      if response == "VERIFIED"
        p "Saving paypal membership transaction"
        cart = UserCart.find_by(tracking_id: params['tracking_id'])
        p "no cart" if !cart
        render status: 200, nothing: true and return if !cart
        

        # logger.info "teacher #{event.teacher_id}, student #{event.student_id}"
        logger.info "returned params #{create_transaction_params_paypal(params, cart.student_id, cart.teacher_id)}"

        # Event.create_confirmed_events(cart)

        transaction = Transaction.create( #payments_helper
                                          create_membership_params(params, cart.teacher_id)
                                        )
        t = Teacher.find_by_email(cart.teacher_email)
        t.update_attributes(paid_up: true, paid_up_date: Date.today - 7.days) #set teacher as payed
        
        MembershipMailer.delay.membership_paid(cart.teacher_email, t.full_name) #send email async with delayed_job
        
        render status: 200, nothing: true
      else
        p "Paypal membership payment didn't work out"
        render status: 200, nothing: true
      end
    elsif transaction
      p "Couldn't find transaction or not payment status not completed"
      render status: 200, nothing: true
    else
      logger.info "MAJOR ALERT: Transaction already exists"
      render status: 200, nothing: true
    end

    # render status: 200, nothing: true
  end

  #end of membership payments

  def create_package_booking_paypal
    p ENV['PAYPAL_USER_ID']
    p ENV['PAYPAL_PASSWORD']
    p ENV['PAYPAL_SIGNATURE']
    p ENV['PAYPAL_APP_ID']
    
    package = Package.find(params[:package_id])
    cart = UserCart.create_package_cart(params, current_teacher, package)
    # redirect_to :back
    client = AdaptivePayments::Client.new(
      :user_id       => ENV['PAYPAL_USER_ID'],
      :password      => ENV['PAYPAL_PASSWORD'],
      :signature     => ENV['PAYPAL_SIGNATURE'],
      :app_id        => ENV['PAYPAL_APP_ID'],
      :sandbox       => true
    )

    client.execute(:Pay,
      :action_type     => "PAY",
      :currency_code   => "EUR",
      :tracking_id     => cart.tracking_id,
      :cancel_url      => "https://www.learnyourlesson.ie",
      :return_url      => "https://www.learnyourlesson.ie/paypal-return?payKey=${payKey}",
      :ipn_notification_url => 'https://www.learnyourlesson.ie/store-package-paypal',
      :receivers => [
        { :email => params[:teacher_email], amount: package.price.to_f } #, primary: true
        # { :email => 'loubotsjobs@gmail.com',  amount: 10 }
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

  def store_package_paypal #ipn destination for package bookings
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

    if !Transaction.find_by(tracking_id: params['tracking_id'])
      if response == 'VERIFIED'
        cart = UserCart.find_by(tracking_id: params['tracking_id'])
        render status: 200, nothing: true and return if !cart

        p "MAJOR ERROR. ROUTED TO WRONG PAYPAL METHOD" if cart.booking_type != 'package'
        package = Package.find(cart.package_id)
        Transaction.create(
                            create_transaction_params_paypal(params, cart.student_id, cart.teacher_id)
                          )

        TeacherMailer.package_email_student(
                                              cart,
                                              package
                                            ).deliver_now
        TeacherMailer.package_email_teacher(
                                              cart,
                                              package
                                            ).deliver_now
        render status: 200, nothing: true
      else #end of response == 'verified'
        p "nope 2"
        render status: 200, nothing: true
      end
    else #end of find transaction
      p "nope 1"
      render status: 200, nothing: true
    end

  end

  def home_booking_paypal
    cart = UserCart.find(session[:cart_id].to_i)
    update_student_address(params) #application controller
    price = Price.find(cart.price_id)
   
    p "cart price #{cart.amount}"
    cart.update_attributes(address:params[:home_address])
    p "start time #{params[:start_time]}"

    
    client = AdaptivePayments::Client.new(
      :user_id       => ENV['PAYPAL_USER_ID'],
      :password      => ENV['PAYPAL_PASSWORD'],
      :signature     => ENV['PAYPAL_SIGNATURE'],
      :app_id        => ENV['PAYPAL_APP_ID'],
      sandbox:       true
    )

    client.execute(:Pay,
      :action_type     => "PAY",
      :currency_code   => "EUR",
      :tracking_id     => cart.tracking_id,
      :cancel_url      => "https://www.learnyourlesson.ie",
      :return_url      => request.referrer,
      :ipn_notification_url => "#{root_url}store-paypal",
      :receivers => [
        { :email => cart.teacher_email, amount: price.price.to_f } #, primary: true
        # { :email => 'loubotsjobs@gmail.com',  amount: 10 }
      ]
    ) do |response|

      if response.success?
        puts "Pay key: #{response.pay_key}"
        logger.info "create paypal response #{response.inspect}"

        # send the user to PayPal to make the payment
        # e.g. https://www.sandbox.paypal.com/webscr?cmd=_ap-payment&paykey=abc
        flash[:success] = "Your booking is being processed. You should receive an email soon."
        redirect_to client.payment_url(response)
      else
        flash[:danger] = "#{response.error_message}"
        puts "Paypal error message: #{response.ack_code}: #{response.error_message}"
        redirect_to :back
      end

    end
  end #end of home_booking_paypal
  
  
  def store_paypal
    render status: 200, nothing: true and return
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

    p "paypal post params: #{params['status']}"
   
    puts "Paypal verification response: #{response}"
    logger.info "Paypal verification response: #{response}"
    
    
    if !(Transaction.find_by(tracking_id: params['tracking_id']))
      if response == "VERIFIED" && params['status'] == 'COMPLETED'
        cart = UserCart.find_by(tracking_id: params['tracking_id'])
        #p "cart #{cart.booking_type}"
        price = Price.find(cart.price_id)
        
        
        render status: 200, nothing: true and return if !cart
        
        if cart.booking_type == "home"
          # p "date %%%%%%%%%%%%% #{Date.parse(cart.params[:date]).strftime('%d/%m%Y')}"
          Event.delay.create_confirmed_events(cart, 'paid')
          
          TeacherMailer.delay.home_booking_mail_teacher(
                                                      cart,
                                                      price.price
                                                    )
          TeacherMailer.delay.home_booking_mail_student(
                                                      cart,
                                                      price.price
                                                    )
          
          transaction = Transaction.create( #payments_helper
                                            create_transaction_params_paypal(params, cart.student_id, cart.teacher_id)
                                          )
          render status: 200, nothing: true
          
        else #not home booking
          # logger.info "teacher #{event.teacher_id}, student #{event.student_id}"
          location = Location.find(cart.location_id.to_i)
          p "not a home booking paypal!!!!!!!!!!!!!!!!"
          logger.info "returned params #{create_transaction_params_paypal(params, cart.student_id, cart.teacher_id)}"

          Event.create_confirmed_events(cart, 'paid')

          transaction = Transaction.create( #payments_helper
                                            create_transaction_params_paypal(params, cart.student_id, cart.teacher_id)
                                          )

          # p "Event errors #{event.errors.full_messages}" if !event.valid?
          # p "Event created id: #{event.id}"
          TeacherMailer.delay.single_booking_mail_teacher(
                                      location.name,
                                      cart,
                                      price.price
                                      
                                    )
          TeacherMailer.delay.single_booking_mail_student(
                                      location.name,
                                      cart,
                                      price.price
                                      
                                    )

          render status: 200, nothing: true
        end


        
      else
        p "Paypal payment didn't work out"
        render status: 200, nothing: true
      end
    elsif transaction
      render status: 200, nothing: true
    else
      p  "MAJOR ALERT: Transaction not found"
      logger.info "MAJOR ALERT: Transaction not found"
      render status: 200, nothing: true
    end

  end  

  def paypal_return
    puts "paypal return params paykey: #{params[:payKey]}"
    require "pp-adaptive"

    client = AdaptivePayments::Client.new(
      :user_id       => ENV['PAYPAL_USER_ID'],
      :password      => ENV['PAYPAL_PASSWORD'],
      :signature     => ENV['PAYPAL_SIGNATURE'],
      :app_id        => ENV['PAYPAL_APP_ID'],
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
        p "paypal ipn address #{root_url}store-paypal"
        cart = UserCart.find(session[:cart_id])
        price = Price.find(cart.price_id).price.to_f
        teacher = Teacher.find(cart.teacher_id)
        
        @amount = price * cart.weeks
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
          :currency_code   => "EUR",
          :tracking_id     => cart.tracking_id,
          :cancel_url      => "https://learn-your-lesson.herokuapp.com",
          :return_url      => request.referrer,
          :ipn_notification_url => "#{root_url}store-paypal",
          :receivers => [
            { :email => teacher.email, amount: @amount }
            # { :email => 'loubotsjobs@gmail.com',  amount: 10 }
          ]
        ) do |response|

          if response.success?
            puts "Pay key: #{response}"
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