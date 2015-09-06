
task :pay_people_on_the_hour => :environment do
	events = Event.where(status: 'held').where("end_time BETWEEN ? AND ?", Time.now - 6.hours, Time.now + 1.hours)
	# pp events
	events.each do |event|
		pp event
		require "pp-adaptive"

		client = AdaptivePayments::Client.new(
		  :user_id       => ENV['PAYPAL_USER_ID'],
		  :password      => ENV['PAYPAL_PASSWORD'],
		  :signature     => ENV['PAYPAL_SIGNATURE'],
		  :app_id        => ENV['PAYPAL_APP_ID'],
		  sandbox:       true
		)

		client.execute(:Pay,
		  :pay_key 					=> event.pay_key,
		  :action_type     	=> "PAY",
		  :receiver_email  	=> "lllouis@yahoo.com",
		  :receiver_amount 	=> 50,
		  :currency_code   	=> "GBP",
		  :ipn_notification_url => "http://38c8396e.ngrok.com/store-paypal",
		  :cancel_url      	=> "http://38c8396e.ngrok.com",
	    :return_url    		=> "http://38c8396e.ngrok.com"
		) do |response|

		  if response.success?
		  	event.update_attributes(status: 'paid')
		    puts "Pay key: #{ response.pay_key }"
		    puts "Status: #{ response.payment_exec_status }"
		  else
		    # puts "#{response.ack_code}: #{response.error_message}"
		    pp response
		  end

		end
	end #end of events.each loop
end
