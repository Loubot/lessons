class AdminMailer < ActionMailer::Base

  def send_feedback_email(params)
    begin
      require 'mandrill'
      m = mandrill = Mandrill::API.new ENV['MANDRILL_APIKEY']
      message = {  
       :subject=> params[:subject],  
       :from_name=> params[:name],
       :from_email => params[:email],
       :text=> params['feedback-info'],  
       :to=>[  
          {
            :email => 'alan.rowell28@googlemail.com',
            :name => 'Admin'
          },
         {  
           :email=> 'louisangelini@gmail.com',
           :name=> 'Admin' 
         }  
       ],  
       :html=> params['feedback-info'],  
       :from_email=> params[:email]  
      }  
      sending = m.messages.send message  
      puts sending
    rescue Mandrill::Error => e
        # Mandrill errors are thrown as exceptions
        logger.info "A mandrill error occurred: #{e.class} - #{e.message}"
        # A mandrill error occurred: Mandrill::UnknownSubaccountError - No subaccount exists with the id 'customer-123'    
    raise
    end
    
  end

end