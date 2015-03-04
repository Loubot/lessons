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
		logger.info "price here #{@price.inspect}"
		p "You hit update"
		@price = Price.find(params[:id])
		logger.info "price here #{@price.inspect}"
		p "price here #{@price.inspect}"
		@name = @price.subject.name
		if @price.update(price_params)
			logger.info 'Well done Louis'
			p "Well done Louis"
		else
			logger.info "Not quite Louis"
			p "Not quite Louis"
		end
		
	end

	private

			def price_params
				params.require(:price).permit!
			end
end