class UserCartsController < ApplicationController
  before_action :authenticate_teacher!

  def teachers_or_students
    render status: 200, nothing: true
  end

  ####################################### payment methods














  ##################################### end of no payment methods

  ####################################### no payment methods

  def select_price_duration #get price id and show check availability form
    session[:price_id] = params[:price_id]
    session[:location_id] = params[:location_id]
    render 'modals/payment_selections/_show_payment_no_locations_modal.js.coffee'
  end

  def check_home_event
    
    @price = Price.find(session[:price_id])
    event = Event.student_do_single_booking(params, @price)
    if event.valid?
      @teacher = Teacher.find(session[:teacher_id]) # teacher not student   
      @event = event
      p "start time #{params[:start_time]}"
      @cart = UserCart.home_booking_cart(params, @price)
      p "cart #{@cart.inspect}"
      session[:cart_id] = @cart.id
      p "event is valid!!!!!!!!!!"
    else
      p "event is not valid &&&&&&&&&&&&&&&&&&S"
      @event = event.errors.full_messages
    end
    render 'modals/payment_selections/_show_total.js.coffee' #display _payments_modal_for_users
  end
  ####################################### end of no payment methods

end