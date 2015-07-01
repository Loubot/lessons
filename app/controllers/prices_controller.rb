class PricesController < ApplicationController
	before_action :authenticate_teacher!
	before_action :check_correct_teacher, except: [:destroy]

	def check_correct_teacher
		if params[:price][:teacher_id].to_i != current_teacher.id
			flash[:danger] = "An error has occrred. Please email louisangelini@gmail.com"
			redirect_to :back
		end
	end

	def create
		# p "params #{price_params[:price]}"
		@price = Price.find_or_initialize_by(subject_id: price_params[:subject_id], \
																					duration: price_params[:duration].to_i, no_map: price_params[:no_map])
		p @price.inspect
		
		# @name = @price.subject.name
		if @price.update_attributes(price_params)

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
				params.require(:price).permit!
			end
end