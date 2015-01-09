class PricesController < ApplicationController
	before_action :authenticate_teacher!

	def create
		@price = Price.find_or_initialize_by(price_params)
		if @price.save
			p "Well done Louis"
		else
			p "Not quite Louis"
		end		
	end

	def update
		@price = Price.find(params[:id])
		if @price.update(price_params)
			p "Well done Louis"
		else
			p "Not quite Louis"
		end
		
	end

	private

			def price_params
				params.require(:price).permit!
			end
end