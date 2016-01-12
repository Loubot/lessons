class ConversationMailer < ActionMailer::Base

  def send_message(email)
    p "Hit ConversationMailer/send_message"
    begin
      require 'mandrill'
      m = mandrill = Mandrill::API.new ENV['MANDRILL_APIKEY']
      message = {  
       :subject=> "Membership expiring",  
       :from_name=> "Learn Your Lesson",  
       :text=> "Your membership is about to expire. Please make sure to subscribe or your profile will not be visible to students.",  
       :to=>[  
         {  
           :email=> email
           # :name=> "#{student_name}"  
         }  
       ],  
       :html=> "Your membership is about to expire. Please make sure to subscribe or your profile will not be visible to students.",  
       :from_email=> "loubot@learnyourlesson.ie" 
      }  
      sending = m.messages.send message  
      puts sending
    rescue Mandrill::Error => e
        # Mandrill errors are thrown as exceptions
        logger.info "A mandrill error occurred: #{e.class} - #{e.message}"
        # A mandrill error occurred: Mandrill::UnknownSubaccountError - No subaccount exists with the id 'customer-123'    
    raise
    end

    logger.info "Mail sent to #{email.to_s}"

  end

  

end