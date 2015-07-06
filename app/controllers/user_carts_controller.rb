class UserCartsController < ApplicationController
  before_action :authenticate_teacher!
  before_action :check_id, except: [ :loc_only_prices ]

  def teachers_or_students
    render status: 200, nothing: true
  end

  def check_availability
    price = Price.find(params[:user_cart][:price_id])
    event = Event.student_do_single_booking(params, price)
    params[:user_cart].parse_time_select! :start_time
    UserCart.create!(user_cart_params)
    p event.inspect
    render status: 200, nothing: true
  end

  def loc_only_prices
    p params
    @teacher = Teacher.find(params['user_cart']['teacher_id'].to_i)
    @prices = @teacher.prices.select { |p| p.location_id == params['user_cart']['location_id'].to_i }
    p @prices.inspect
    # render status: 200, nothing: true
  end
  
  private

  def user_cart_params
    params.require(:user_cart).permit!
  end

  def check_id
    redirect_to root_url if params[:id].to_i != current_teacher.id
  end

end