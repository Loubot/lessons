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
		@subjects = params[:search] == '' ? [] : Subject.where('name ILIKE ?', "%#{params[:search]}%")
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
			pay_request = PaypalAdaptive::Request.new

			data = {
			"returnUrl" => "http://learn-your-lesson.herokuapp.com", 
			"requestEnvelope" => {"errorLanguage" => "en_US"},
			"currencyCode"=>"EUR",  
			"receiverList"=>{"receiver"=>[{"email"=>"tlouisangelini@gmail.com", "amount"=>"10.00"}]},
			"cancelUrl"=>"http://learn-your-lesson.com",
			"actionType"=>"PAY",
			"ipnNotificationUrl"=>"http://learn-your-lesson.herokuapp.com"
			}

			pay_response = pay_request.pay(data)

			if pay_response.success?
				flash[:success] = pay_response.preapproval_paypal_payment_url
				# render 'welcome'
			  redirect_to pay_response.preapproval_paypal_payment_url
			else
			  puts pay_response.errors.first['message']
			  redirect_to failed_payment_url
			end
		end
end


# Credential	API Signature
# API Username	lllouis_api1.yahoo.com
# API Password	MRXUGXEXHYX7JGHH
# Signature	AFcWxV21C7fd0v3bYYYRCpSSRl31Akm0pm37C5ZCuhi7YDnTxAVFtuug
#https://github.com/paypal/adaptivepayments-sdk-ruby

#curl -s --insecure -H "X-PAYPAL-SECURITY-USERID: lllouis_api1.yahoo.com" -H "X-PAYPAL-SECURITY-PASSWORD: MRXUGXEXHYX7JGHH" -H "X-PAYPAL-SECURITY-SIGNATURE: AFcWxV21C7fd0v3bYYYRCpSSRl31Akm0pm37C5ZCuhi7YDnTxAVFtuug" -H "X-PAYPAL-REQUEST-DATA-FORMAT: JSON" -H "X-PAYPAL-RESPONSE-DATA-FORMAT: JSON" -H "X-PAYPAL-APPLICATION-ID: APP-80W284485P519543T" https://svcs.sandbox.paypal.com/AdaptivePayments/Pay -d "{\"actionType\":\"PAY\", \"currencyCode\":\"USD\", \"receiverList\":{\"receiver\":[{\"amount\":\"1.00\",\"email\":\"rec1_1312486368_biz@gmail.com\"}]}, \"returnUrl\":\"http://www.example.com/success.html\", \"cancelUrl\":\"http://www.example.com/failure.html\", \"requestEnvelope\":{\"errorLanguage\":\"en_US\", \"detailLevel\":\"ReturnAll\"}}"
