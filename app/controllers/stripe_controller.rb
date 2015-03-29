class StripeController < ApplicationController

  include PaymentsHelper
  protect_from_forgery except: [:store_stripe, :stripe_create, :stripe_auth_user]
  before_action :get_event_id, only: [:store_stripe]

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

  def single_booking_stripe
  	p "params %%%%%%%%%%%% #{params}"
  	cart = UserCart.home_booking_cart(params)
    p "cart $$$$$$$$$$$$$$$$$$$$$ #{cart.inspect}"
  	render status: 200, nothing: true
  end #end of single_booking_stripe

  def store_stripe
    
    json_response = JSON.parse(request.body.read)

    render status: 200, nothing: true and return if json_response['type'] == "application_fee.created"
    render status: 200, nothing: true and return if json_response['data']['object']['object'] == 'balance'

    # logger.info "Stripe webhook response: #{json_response}"
    logger.info "Store-stripe params #{json_response['data']['object']['metadata']['tracking_id']}"
    
    if !(Transaction.find_by(tracking_id: json_response['data']['object']['metadata']['tracking_id']))
      cart = UserCart.find_by(tracking_id: json_response['data']['object']['metadata']['tracking_id'])
      puts "Cart %%%  #{cart.inspect}"
      render status: 200, nothing: true and return if !cart
      # event = Event.create_confirmed_bookings(cart.params)

      Event.create_confirmed_events(cart)
      
      cart_params = cart.params
      puts "cart params #{cart_params}"
      puts "start time #{cart_params[:start_time]}"
  
      
      Transaction.create(
                        create_transaction_params_stripe(json_response, cart.student_id, cart.teacher_id)
                        )

      TeacherMailer.mail_teacher(
                                  cart.student_email,
                                  cart.student_name,
                                  cart.teacher_email,
                                  cart.params[:start_time],
                                  cart.params[:end_time]
                                ).deliver_now

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