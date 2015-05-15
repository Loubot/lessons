class MembershipMailer < ActionMailer::Base
  include Devise::Mailers::Helpers

  def membership_paid(teacher_email)
    p 'membership_paid mail start'    
    begin
      require 'mandrill'
      m = mandrill = Mandrill::API.new ENV['MANDRILL_APIKEY']
      message = {  
       :subject=> "Membership paid",  
       :from_name=> "Learn Your Lesson",  
       :text=> "Your membership for the next month has been paid",  
       :to=>[  
         {  
           :email=> teacher_email.to_s
           # :name=> "#{student_name}"  
         }  
       ],  
       :html=> "Your membership for the next month has been paid",  
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

    logger.info "Mail sent to #{teacher_email.to_s}"
  end

  def pay_up_time(teacher_email)
     p 'pay_up_time mail start'    
    begin
      require 'mandrill'
      m = mandrill = Mandrill::API.new ENV['MANDRILL_APIKEY']
      message = {  
       :subject=> "Membership expiring",  
       :from_name=> "Learn Your Lesson",  
       :text=> "Your membership is about to expire. Please make sure to subscribe or your profile will not be visible to students.",  
       :to=>[  
         {  
           :email=> teacher_email.to_s
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

    logger.info "Mail sent to #{teacher_email.to_s}"
  end

end