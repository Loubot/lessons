class StaticController < ApplicationController

	include StaticHelper	
	
	def how_it_works

	end

	def mailing_list
		
	end

	def welcome
		@paypal_url = create_paypal
	end

	def learn

	end

	def teach

	end

	def add_to_list
		gb = Gibbon::API.new(ENV['_mail_chimp_api'], { :timeout => 15 })
		flash[:notice] = params
		if valid_email?(params[:email])
			begin
				gb.lists.subscribe({:id => ENV['_mail_chimp_list'], :email => {:email => params[:email] },:double_optin => false})
			rescue Gibbon::MailChimpError, StandardError => e
				flash[:danger] = e
			end
		end
		redirect_to :back
	end

	def subject_search
		@subjects = params[:search] == '' ? [] : Subject.where('name LIKE ?', "%#{params[:search]}%")
		render json: @subjects
	end

	def display_subjects
		@params = params
		@teachers = get_search_results(params)
		
	end

	private

		def valid_email?(email)
			valid_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
			email =~ valid_regex
		end

		def create_paypal
			values = {
				:'X-PAYPAL-SECURITY-USERID' => 'lllouis_api1.yahoo.com',
				:'X-PAYPAL-SECURITY-PASSWORD' => 'MRXUGXEXHYX7JGHH',
				:'X-PAYPAL-SECURITY-SIGNATURE' => 'AFcWxV21C7fd0v3bYYYRCpSSRl31Akm0pm37C5ZCuhi7YDnTxAVFtuug',
				actionType: 'PAY',
				:'X-PAYPAL-APPLICATION-ID' => 'ASWtURAkgXGnKk7ugaH9CqmCE8McNDwYgupFtYMWxKbrYbdKedJ36OsYRWzI',
				:'receiverList.receiver(0).email' => 'louisangelini@gmail.com',
				:'receiverList.receiver(0).amount' => '10',
				currencyCode: 'GBP',
				cancelUrl: 'http://learn-your-lesson.herokuapp.com',
				returnUrl: 'http://learn-your-lesson.herokuapp.com'

			}
			url = "https://svcs.sandbox.paypal.com/AdaptivePayments/Pay?" +  values.to_query
		end
end


# Credential	API Signature
# API Username	lllouis_api1.yahoo.com
# API Password	MRXUGXEXHYX7JGHH
# Signature	AFcWxV21C7fd0v3bYYYRCpSSRl31Akm0pm37C5ZCuhi7YDnTxAVFtuug
#https://github.com/paypal/adaptivepayments-sdk-ruby