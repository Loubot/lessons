class PricesController < ApplicationController
	before_action :authenticate_teacher!

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