class PricesController < ApplicationController
	before_action :authenticate_teacher!
	before_action :check_correct_teacher

	def check_correct_teacher
		p "blb #{params[:price][:teacher_id]}"
		if params[:price][:teacher_id].to_i != current_teacher.id
			flash[:danger] = "An error has occrred. Please email louisangelini@gmail.com"
			redirect_to :back
		end
	end

	def create
		@price = Price.find_or_initialize_by(price_params)
		
		@name = @price.subject.name
		if @price.save

			@message = "<p class='price_alert_message'> #{@name} price updated </p>".html_safe
		else
			
			@message = @price.errors.full_messages.split(',').join(", ")
		end		
	end

	def update
		@price = Price.find(params[:id])
		
		@name = @price.subject.name
		if @price.update(price_params)
			
			@message = "<p class='price_alert_message'> #{@name} price updated </p>".html_safe
		else
			
			@message = @price.errors.full_messages.split(',').join(", ")
		end
		
	end

	def destroy
		@price = Price.find(params[:id])
		@price.destroy
	end

	private

			def price_params
				params.require(:price).permit!
			end
end