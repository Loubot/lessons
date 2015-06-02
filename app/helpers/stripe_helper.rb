module StripeHelper


	def create_transaction_params_stripe(params, student_id, teacher_id) #format params for transaction, stripe
    p "stripe params #{params['source']['name']}"
    returnParams = { 
                      # tracking_id: params['data']['object']['metadata']['tracking_id'], 
                      trans_id: params['id'],
                      sender: params['source']['name'], 
                      payStripe: 'stripe', 
                      user_id: student_id,
                      teacher_id: teacher_id, 
                      pay_date: Time.at(params['created'].to_i), 
                      # tracking_id: params['data']['object']['metadata']['tracking_id'], 
                      whole_message: params,
                      amount: (sprintf "%.2f", (params[:amount].to_f / 100)) #convert to decimal
                    }
    # logger.info "stripe post params sender_email: #{params['data']['object']['card']['name']}"
    # logger.info "stripe post params trans_id: #{params['id']}"
    # logger.info "stripe post params paypal/stripe: #{'stripe'}"
    # logger.info "stripe post params teacher_id #{teacher_id}"
    # logger.info "stripe post params student_id #{student_id}"
    # logger.info "stripe post params date: #{params['created']}"
    # logger.info "stripe post params tracking_id: #{params['data']['object']['metadata']['tracking_id']}"
    # logger.info "stripe post params whole message: #{params.to_s}"
    returnParams
  end # end of create_transaction_params_stripe

  def home_booking_transaction(json_response, student_id, teacher_id)
    Transaction.create!(
                        create_transaction_params_stripe(json_response, student_id, teacher_id)
                      )

  end #end of home_booking_transaction_and_mail

  def create_membership_params(params, teacher)
    returnParams = { 
                      tracking_id: params['data']['object']['metadata']['tracking_id'], 
                      trans_id: params['id'],
                      sender: params['data']['object']['card']['name'], 
                      payStripe: 'stripe', 
                      user_id: 0,
                      teacher_id: teacher, 
                      pay_date: Time.at(params['created'].to_i),
                      tracking_id: params['data']['object']['metadata']['tracking_id'], 
                      whole_message: params 
                    }
    
  end

  
	def transaction_and_mail(json_response, cart)
		Transaction.create(
		                  	create_transaction_params_stripe(json_response, cart.student_id, cart.teacher_id)
		                  )

		TeacherMailer.delay.mail_teacher(
		                            cart.student_email,
		                            cart.student_name,
		                            cart.teacher_email,
		                            cart.params[:start_time],
		                            cart.params[:end_time]
		                          )
	end # end of transaction_and_mail

  def package_transaction_and_mail(json_response, cart, package)
    Transaction.create(
                        create_transaction_params_stripe(json_response, cart.student_id, cart.teacher_id)
                      )

    TeacherMailer.delay.paypal_package_email(
                                        cart.student_email,
                                        cart.student_name,
                                        cart.teacher_email,
                                        package
                                      )

  end # end of package_transaction_and_mail
end