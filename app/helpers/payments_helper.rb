module PaymentsHelper 
  def create_transaction_params_paypal(params, student_id, teacher_id) #format params for transaction, paypal
    returnParams = { 
                    tracking_id: params[:tracking_id], 
                    trans_id: params['transaction']['0']['.id_for_sender_txn'],
                    sender: params['sender_email'], 
                    payStripe: 'paypal', 
                    user_id: student_id, 
                    teacher_id: teacher_id,
                    pay_date: params['payment_request_date'], 
                    tracking_id: params['tracking_id'], 
                    whole_message: params
                   }
    logger.info "paypal post params sender_email: #{params['sender_email']}"
    logger.info "paypal post params trans_id: #{params['transaction']['0']['.id_for_sender_txn']}"
    logger.info "paypal post params paypal/stripe: #{'paypal'}"
    logger.info "paypal post params teacher_id #{teacher_id}"
    logger.info "paypal post params student_id #{student_id}"
    logger.info "paypal post params date: #{params['payment_request_date']}"
    logger.info "paypal post params tracking_id: #{params['tracking_id']}"
    logger.info "paypal post params whole message: #{params}"
    returnParams
  end
  
end
