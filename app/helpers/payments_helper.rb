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
    
    returnParams
  end

  def create_membership_params(params, teacher)
    returnParams = { 
                    tracking_id: params[:tracking_id], 
                    trans_id: params['transaction']['0']['.id_for_sender_txn'],
                    sender: params['sender_email'], 
                    payStripe: 'paypal', 
                    user_id: 0, 
                    teacher_id: teacher,
                    pay_date: params['payment_request_date'], 
                    tracking_id: params['tracking_id'], 
                    whole_message: params
                   }
  end
  
end


#validates :sender, :user_id, :teacher_id, :pay_date, :whole_message, :trans_id, :tracking_id, :payStripe, :whole_message,  presence: true