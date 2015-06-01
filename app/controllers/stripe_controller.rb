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
   # Amount in cents
  	puts "tracking_id%%%%%%%%% #{params[:tracking_id]}"
    @amount = params[:amount].to_i * 100    
    @teacher = Teacher.find(params[:teacher_id])
    charge = Stripe::Charge.create({
      :metadata           => { :tracking_id => params[:tracking_id] },
      :amount             => @amount,
      :description        => "#{params[:tracking_id]}",
      :currency           => 'eur',
      :application_fee    => 300,
      :source             => params[:stripeToken]
      
      },
      @teacher.stripe_access_token
    )
    puts charge.inspect
    if charge['paid'] == true
      # cart = UserCart.find_by(tracking_id: charge['metadata']['tracking_id'])
      # event = Event.create!(cart.params)
      # puts "Stripe successful event created id: #{event.id}"
    end
    flash[:success] = 'Payment was successful. You will receive an email soon. Eventually. When I code it!'
    redirect_to root_url

    rescue Stripe::CardError => e
      flash[:error] = e.message
      redirect_to charges_path
    
  end #end of stripe_create

  #start of membership payments
  def pay_membership_stripe
    cart = UserCart.membership_cart(current_teacher.id, current_teacher.email)
    @amount = 300
    charge = Stripe::Charge.create({
      :metadata           => { 
                              :tracking_id => cart.tracking_id, 
                              home_booking: true
                              },
      :amount             => @amount,
      :description        => cart.tracking_id,
      :currency           => 'eur',
      :application_fee    => 300,
      :source             => params[:stripeToken]
      
      },
      current_teacher.stripe_access_token
    )
    puts charge.inspect
    if charge['paid'] == true
      # cart = UserCart.find_by(tracking_id: charge['metadata']['tracking_id'])
      # event = Event.create!(cart.params)
      # puts "Stripe successful event created id: #{event.id}"
    end
    flash[:success] = 'Payment was successful. You will receive an email soon. Eventually. When I code it!'
    redirect_to :back

    rescue Stripe::CardError => e
      flash[:error] = e.message
      redirect_to charges_path
  end

  #end of membership payments

  def home_booking_stripe

    update_student_address(params) #application controller

    price = Price.find(params[:price_id])
    
    if params[:home_address] == ''
      flash[:danger] = "Address can't be blank"
      redirect_to :back and return
    end
    
  	cart = UserCart.home_booking_cart(params,price.price)
    p "cart $$$$$$$$$$$$$$$$$$$$$ #{cart.tracking_id}"
  	# 

  	@amount = (price.price * 100 ).to_i
    @teacher = Teacher.find(params[:teacher_id])
    charge = Stripe::Charge.create({
      :metadata           => { 
                              :tracking_id => cart.tracking_id, 
                              home_booking: true
                              },
      :amount             => @amount,
      :description        => cart.tracking_id,
      :currency           => 'eur',
      :application_fee    => 300,
      :source             => params[:stripeToken]
      
      },
      @teacher.stripe_access_token
    )
    puts charge.inspect
    if charge['paid'] == true
      # cart = UserCart.find_by(tracking_id: charge['metadata']['tracking_id'])
      # event = Event.create!(cart.params)
      # puts "Stripe successful event created id: #{event.id}"
    end
    flash[:success] = 'Payment was successful. You will receive an email soon. Eventually. When I code it!'
    redirect_to root_url

    rescue Stripe::CardError => e
      flash[:error] = e.message
      redirect_to charges_path

  end #end of single_booking_stripe

  def create_package_booking_stripe
    p "params #{params}"
    package = Package.find(params[:package_id])
    @teacher = Teacher.find(params[:teacher_id])
    cart = UserCart.create_package_cart(params, current_teacher, package)
    charge = Stripe::Charge.create({
      :metadata           => { :tracking_id => cart.tracking_id},
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
      # cart = UserCart.find_by(tracking_id: charge['metadata']['tracking_id'])
      # event = Event.create!(cart.params)
      # puts "Stripe successful event created id: #{event.id}"
    end
    flash[:success] = 'Payment was successful. You will receive an email soon. Payments can take a few minutes to register.'
    redirect_to root_url

    rescue Stripe::CardError => e
      flash[:error] = e.message
      redirect_to charges_path
    
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
      render status: 200, nothing: true and return if !cart

      p "%%%%%%%% #{json_response['data']['object']['metadata']['home_booking']}"

      if cart.booking_type == 'home' #if it's a home booking
      	home_booking_transaction_and_mail(json_response, cart) #stripe helper
        p "***************** home booking"
        render status: 200, nothing: true
      elsif cart.booking_type == 'package' 
        package = Package.find(cart.package_id)

        package_transaction_and_mail(json_response, cart, package) #stripe helper
        render status: 200, nothing: true
      elsif cart.booking_type == 'membership'
        
        p "stripe membership payment"
        transaction = Transaction.create( #payments_helper
                                          create_membership_params(params, cart.teacher_id)
                                        )

        t = Teacher.find_by_email(cart.teacher_email)
        t.update_attributes(paid_up: true, paid_up_date: Date.today - 7.days) #set teacher as paid
        
        MembershipMailer.delay.membership_paid(cart.teacher_email, t.full_name) #send email async with delayed_job
        render status: 200, nothing: true
        
      else #it's not a home booking or a package
      	Event.create_confirmed_events(cart)
      	
      	cart_params = cart.params
      	puts "cart params #{cart_params}"
      	puts "start time #{cart_params[:start_time]}"

      	transaction_and_mail(json_response, cart) #stripe_helper      
      	

      	# Transaction.create!(json_response)
      	render status: 200, nothing: true

      end
      # event = Event.create_confirmed_bookings(cart.params)

      
    else #no transaction found, render nothing
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
    if json_resp['access_token'].present?
      @teacher = Teacher.find(params['state'].to_i)
      flash[:success] = "Successfully registered with Stripe"
      @teacher.update_attributes(stripe_access_token: json_resp['access_token'], stripe_user_id: json_resp['stripe_user_id'])
    end
    flash[:success] = 'Stripe code updated'
    redirect_to edit_teacher_path(id: params[:state])
  end




  protected

    def fix_json_params
      if request.content_type == "application/json"
        @reparsed_params = JSON.parse(request.body.string).with_indifferent_access
      end
    end



end