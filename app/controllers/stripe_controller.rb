class StripeController < ApplicationController
	include StripeHelper
  
  protect_from_forgery except: [:store_stripe, :stripe_create, :stripe_auth_user]
  before_action :get_event_id, only: [:store_stripe]
  before_action :authenticate_teacher!, only: [:stripe_create, :home_booking_stripe, :pay_membership_stripe]
  before_action :fix_json_params, only: [:store_stripe]

  def get_event_id
    @event_id = session[:event_params] || []
  end


  def stripe_create
       
    p "session #{session[:cart_id]}"
    cart = UserCart.find(session[:cart_id].to_i)
    @teacher = Teacher.find(cart.teacher_id)

    # Amount in cents
    price = Price.find(cart.price_id)
    @amount = (price.price * 100 ).to_i
    lesson_location = Location.find(cart.location_id).name
    
    begin
      charge = Stripe::Charge.create({
        :metadata           => { :tracking_id => params[:tracking_id] },
        :amount             => @amount,
        :description        => "#{params[:tracking_id]}",
        :currency           => 'eur',
        # :application_fee    => 300,
        :source             => params[:stripeToken]
        
        },
        @teacher.stripe_access_token
      )
      # p "cart #{cart.inspect}"
      # puts charge.inspect
      if charge['paid'] == true
        Event.delay.create_confirmed_events(cart, 'paid') #Event model, checks if multiple or not   
        single_transaction_and_mails(charge, params, lesson_location, cart, price) #stripe_helper
        
        flash[:success] = 'Payment was successful. You should receive an email soon.'
           
        redirect_to :back  
      
      end #end of if
    

    rescue Stripe::CardError => e
      flash[:error] = e.message
      redirect_to :back
    end #end of begin/rescue
    
    
  end #end of stripe_create

  #start of membership payments
  def pay_membership_stripe
    # cart = UserCart.membership_cart(current_teacher.id, current_teacher.email)
    @amount = 300
    begin
      charge = Stripe::Charge.create({
        :metadata           => { 
                                # :tracking_id => cart.tracking_id, 
                                home_booking: true
                                },
        :amount             => @amount,
        :description        => "#{current_teacher.full_name} membership payment",
        :currency           => 'eur',
        :application_fee    => 300,
        :source             => params[:stripeToken]
        
        },
        current_teacher.stripe_access_token
      )
      puts charge.inspect
      if charge['paid'] == true
        p "stripe membership payment"
        transaction = Transaction.create( #payments_helper
                                          create_membership_params(charge, params['teacher_id'])
                                        )

        
        # current_teacher.update_attributes(paid_up: true, paid_up_date: Date.today - 7.days) #set teacher as paid
        
        MembershipMailer.delay.membership_paid(params[:teacher_email], current_teacher.full_name) #send email async with delayed_job
      end
      flash[:success] = 'Payment was successful. You will receive an email soon. Eventually. When I code it!'
      redirect_to :back

    rescue Stripe::CardError => e
      flash[:error] = e.message
      redirect_to charges_path
    end #end of begin/rescue
    
  end

  #end of membership payments

  def home_booking_stripe
    p "stripe submit"

    update_student_address(params) #application controller

    p "params #{params[:home_address]}"
    cart = UserCart.find(session[:cart_id].to_i)
    price = Price.find(cart.price_id.to_i)

    cart.update_attributes(address:params[:home_address])
    if params[:home_address] == ''
      flash[:danger] = "Address can't be blank"
      redirect_to :back and return
    end
    
  	
    
  	@amount = (price.price * 100 ).to_i
    @teacher = Teacher.find(cart.teacher_id)
    charge = Stripe::Charge.create({
      :metadata           => { 
                              :tracking_id => cart.tracking_id, 
                              home_booking: true
                              },
      :amount             => @amount,
      :description        => cart.tracking_id,
      :currency           => 'eur',
      :source             => params[:stripeToken]
      
      },
      @teacher.stripe_access_token
    )
    
    # p "charge inspection #{charge.inspect}"
    if charge['paid'] == true
      flash[:success] = 'Payment was successful. You will receive an email soon. Time and date to be confirmed'      

      home_booking_transaction(charge, cart.student_id, cart.teacher_id)

      Event.delay.create_confirmed_events(cart, 'paid')

      TeacherMailer.delay.home_booking_mail_teacher(
                                                      cart,
                                                      price.price
                                                    )
      TeacherMailer.delay.home_booking_mail_student(
                                                      cart,
                                                      price.price
                                                    )

      redirect_to :back and return
    else
      flash[:danger] = "Payment failed"
      redirect_to :back
    end
    

    rescue Stripe::CardError => e
      flash[:error] = e.message
      redirect_to charges_path

  end #end of home_booking_stripe

  def create_package_booking_stripe
    p "params #{params}"
    package = Package.find(params[:package_id])
    @teacher = Teacher.find(params[:teacher_id])
    cart = UserCart.create_package_cart(params, current_teacher, package)
    begin
      charge = Stripe::Charge.create({
        :metadata           => { :tracking_id => cart.tracking_id },
        :amount             => package.price.to_i * 100,
        :description        => cart.tracking_id,
        :currency           => 'eur',
        :application_fee    => 300,
        :source             => params[:stripeToken]
        
        },
        @teacher.stripe_access_token
      )
      puts charge.inspect
      if charge['paid'] == true
        package = Package.find(cart.package_id)

        package_transaction_and_mail(charge, cart, package) #stripe helper
      end
      flash[:success] = 'Payment was successful. You will receive an email soon. Payments can take a few minutes to register.'
      redirect_to root_url

      rescue Stripe::CardError => e
        flash[:error] = e.message
        redirect_to charges_path
    end
    
  end #end of create_package_booking_stripe

  def store_stripe
    
    json_response = JSON.parse(request.body.read)

    render status: 200, nothing: true and return if json_response['type'] == "application_fee.created"
    render status: 200, nothing: true and return if json_response['data']['object']['object'] == 'balance'

    # logger.info "Stripe webhook response: #{json_response}"
       
    logger.info "Store-stripe params #{json_response['data']['object']['metadata']['tracking_id']}"
    
    if !(Transaction.find_by(tracking_id: json_response['data']['object']['metadata']['tracking_id']))
      cart = UserCart.find_by(tracking_id: json_response['data']['object']['metadata']['tracking_id'])
      # puts "Cart %%%  #{cart.inspect}"
      # p "cart $$$$$$$$$$$$$$$$$$$$$ #{cart.tracking_id}"
      p "No cart" if !cart
      render status: 200, nothing: true and return if !cart

      p "%%%%%%%% #{json_response['data']['object']['metadata']['home_booking']}"

      if cart.booking_type == 'home' #if it's a home booking
      	
        p "***************** home booking"
        render status: 200, nothing: true
      elsif cart.booking_type == 'package' 
        
        render status: 200, nothing: true
      elsif cart.booking_type == 'membership'        
        
        render status: 200, nothing: true
        
      else #it's not a home booking or a package
      	# Event.create_confirmed_events(cart)
      	
      	# cart_params = cart.params
      	# puts "cart params #{cart_params}"
      	# puts "start time #{cart_params[:start_time]}"

      	   
      	

      	# Transaction.create!(json_response)
      	render status: 200, nothing: true

      end
      # event = Event.create_confirmed_bookings(cart.params)

      
    else #no transaction found, render nothing
      p "Couldn't find transaction"
      render status: 200, nothing: true
    end   #end of !if Transaction
  end #end of store_stripe


  def stripe_auth_user
    p "HELL EHL"
    p "YEA YEA #{ENV['STRIPE_SECRET_KEY']}"
    uri = URI.parse('https://connect.stripe.com/oauth/token')
    uri.query = URI.encode_www_form({
        'client_secret' => ENV['STRIPE_SECRET_KEY'], 'code' => params[:code],
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
    @teacher = Teacher.find(params['state'].to_i)
    if json_resp['access_token'].present?
      
      @teacher.update_attributes(stripe_access_token: json_resp['access_token'], stripe_user_id: json_resp['stripe_user_id'])
      flash[:success] = 'Successfully registered with Stripe. Stripe code updated'
    else
      flash[:danger] = "Couldn't update stripe code. #{json_resp['error']}"
      @teacher.update_attributes(stripe_access_token: '')
    end
    
    redirect_to edit_teacher_path(id: params[:state])
  end




  protected

    def fix_json_params
      if request.content_type == "application/json"
        @reparsed_params = JSON.parse(request.body.string).with_indifferent_access
      end
    end



end