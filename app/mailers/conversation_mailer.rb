class ConversationMailer < ActionMailer::Base

  def send_message(email, id, message_id,  random)
    p "Hit ConversationMailer/send_message"
    p "<a href='#{ root_url }?id=#{ id }"
    begin
      require 'mandrill'
      m = mandrill = Mandrill::API.new ENV['MANDRILL_APIKEY']
      message = {  
       :subject=> "Membership expiring",  
       :from_name=> "Learn Your Lesson",  
       :text=> "You have a new message. Paste this link to view it. "  + \
                            "#{ root_url }conversations/#{ id }?random=#{ random }&message_id=#{ message_id }",  
       :to=>[  
         {  
           :email=> email
           # :name=> "#{student_name}"  
         }  
       ],  
       :html=> "<a href='#{ root_url }conversations/#{ id }?random=#{ random }&message_id=#{ message_id }'>View your new message</a>",  
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