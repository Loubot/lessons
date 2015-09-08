class UserCartsController < ApplicationController
  before_action :authenticate_teacher!
  before_action :check_id, except: [ :loc_only_prices ]

  def teachers_or_students
    render status: 200, nothing: true
  end

  def check_availability #run event checker in event model
    @teacher= Teacher.find(session[:teacher_id].to_i)
    @price = Price.find(params[:user_cart][:price_id])
    @event = Event.student_do_single_booking(params, @price) #if for event validation in check_availabilit.js
    

    user_cart_params[:start_time] = Time.zone.parse("#{params[:user_cart][:date]} #{params[:user_cart]['start_time(5i)']}")
    user_cart_params.delete :date
    user_cart_params.delete 'start_time(5i)'
    p "user_cart_params #{user_cart_params}"
    @cart = UserCart.create!(user_cart_params)
    @cart.update_attributes(price_id: @price.id)
    session[:cart_id] = @cart.id

    p @event.inspect
    # render status: 200, nothing: true
  end

  def loc_only_prices 
    @teacher = Teacher.find(params['user_cart']['teacher_id'].to_i)
    @prices = @teacher.prices.select { |p| p.location_id == params['user_cart']['location_id'].to_i && \
                                          p.subject_id == params['user_cart']['subject_id'].to_i }
    # p @prices.inspect
    # render status: 200, nothing: true
  end

  def select_home_or_location #return correct form for home or location bookings
    @selection = params[:location_choice]
    @teacher = Teacher.includes(:prices).find(params[:teacher_id])
    @subject = Subject.find(params[:subject_id])
    @prices = @teacher.prices.where(subject_id: params[:subject_id])

    if params[:location_choice] == '1'
      @home_prices = @prices.select { |p| p.location_id == nil } #only home prices
    else
      @location_prices = @prices.select { |p| p.location_id != nil } #only location prices
      @locations = @teacher.locations
      @only_locs = @teacher.locations.find( @location_prices.map { |p| p.location_id }.compact)
    end
   
  end
  
  private

  def user_cart_params
    params.require(:user_cart).permit!
  end

  def check_id
    redirect_to root_url if params[:id].to_i != current_teacher.id
  end

end