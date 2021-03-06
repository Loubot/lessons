module StripeHelper


	def create_transaction_params_stripe(params, student_id, teacher_id) #format params for transaction, stripe
    # p "stripe params #{params['source']['name']}"
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

  def create_membership_params(params, teacher_id)
    returnParams = { 
                      # tracking_id: params['data']['object']['metadata']['tracking_id'], 
                      trans_id: params['id'],
                      sender: params['source']['name'], 
                      payStripe: 'stripe', 
                      user_id: 0,
                      teacher_id: teacher_id, 
                      pay_date: Time.at(params['created'].to_i),
                      # tracking_id: params['data']['object']['metadata']['tracking_id'], 
                      whole_message: params 
                    }
    
  end

  
	def single_transaction_and_mails(charge, params, lesson_location, cart, price)
    # puts "stripe helper params1 #{Date.parse(cart.params[:date]).strftime("%Y")}"
    if cart.weeks.to_i == 0
      amount = (charge['amount'].to_f)
    else
      amount = cart.weeks * ((charge['amount'].to_f ))
    end
		Transaction.create(
		                  	create_transaction_params_stripe(
                                                          charge, 
                                                          cart.student_id, 
                                                          cart.teacher_id
                                                        )
		                  )

    TeacherMailer.delay.single_booking_mail_teacher(                                                
                                                
                                                      lesson_location,
                                                      cart,
                                                      price.price               		                            
                    		                            )

    TeacherMailer.delay.single_booking_mail_student(
                                                  
                                                      lesson_location,
                                                      cart,
                                                      price.price
                                                    )
	end # end of single_transaction_and_mail

  def package_transaction_and_mail(charge, cart, package)
    Transaction.create(
                        create_transaction_params_stripe(
                                                          charge, 
                                                          cart.student_id, 
                                                          cart.teacher_id
                                                        )
                      )

    TeacherMailer.delay.package_email_teacher(
                                              cart,
                                              package
                                            )

  end # end of package_transaction_and_mail
end