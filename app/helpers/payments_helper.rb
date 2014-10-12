module PaymentsHelper
  def create_transaction_params_paypal(params, student_id, teacher_id)
    returnParams = { tracking_id: params[:tracking_id], trans_id: params['transaction']['0']['.id_for_sender_txn'],
      sender: params['sender_email'], payStripe: 'paypal', user_id: student_id, teacher_id: teacher_id,
       pay_date: params['payment_request_date'], tracking_id: params['tracking_id'], whole_message: params.to_s }
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

  def create_transaction_params_stripe(params, student_id, teacher_id)
    returnParams = { tracking_id: params['data']['object']['metadata']['tracking_id'], trans_id: params['id'],
                    sender: params['data']['object']['card']['name'], payStripe: 'stripe', user_id: student_id,
                    teacher_id: teacher_id, pay_date: Time.at(params['created'].to_i),
                    tracking_id: params['data']['object']['metadata']['tracking_id'], whole_message: params.to_s }
    logger.info "stripe post params sender_email: #{params['data']['object']['card']['name']}"
    logger.info "stripe post params trans_id: #{params['id']}"
    logger.info "stripe post params paypal/stripe: #{'stripe'}"
    logger.info "stripe post params teacher_id #{teacher_id}"
    logger.info "stripe post params student_id #{student_id}"
    logger.info "stripe post params date: #{params['created']}"
    logger.info "stripe post params tracking_id: #{params['data']['object']['metadata']['tracking_id']}"
    logger.info "stripe post params whole message: #{params.to_s}"
    returnParams
  end
end
