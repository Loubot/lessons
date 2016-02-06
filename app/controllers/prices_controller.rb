# == Schema Information
#
# Table name: prices
#
#  id          :integer          not null, primary key
#  subject_id  :integer
#  teacher_id  :integer
#  created_at  :datetime
#  updated_at  :datetime
#  location_id :integer
#  price       :decimal(8, 2)
#  duration    :integer          default(0)
#

class PricesController < ApplicationController
	before_action :authenticate_teacher!
	before_action :check_correct_teacher, except: [:destroy]

	def check_correct_teacher
		if params[:price][:teacher_id].to_i != current_teacher.id
			flash[:danger] = "You are not the correct teacher"
			redirect_to :back
		end
	end

	def create
		# p "params #{price_params[:price]}"
		
		@price = Price.new(price_params)
		# p @price.inspect
		
		# @name = @price.subject.name
		if @price.save

			# @message = "<p class='price_alert_message'> #{@name} price updated </p>".html_safe
			flash[:success] = "Prices updated"
		else
			
			# @message = @price.errors.full_messages.split(',').join(", ")
			flash[:danger] = "Couldn't update prices #{@price.errors.full_messages}"
		end		
		redirect_to :back
	end

	def update
		@price = Price.find(params[:id])
		if params[:price][:price].to_f == 0
			@price.destroy
			puts "deleted"
			render status: 200 and return
		end
		@name = @price.subject.name
		if @price.update(price_params)
			
			@message = "<p class='price_alert_message'> #{@name} price updated </p>".html_safe
		else
			
			@message = @price.errors.full_messages.split(',').join(", ")
		end
		
	end

	def destroy
		@price = Price.find(params[:id])
		# p @price.inspect
		@price.destroy
		redirect_to :back
	end

	private

			def price_params
				params.require(:price).permit(:subject_id, :teacher_id, :location_id, :no_map, :duration, :price, :id)
			end
end
