class TeacherMailer < ActionMailer::Base

  def test_mail(recipient)

    begin
      require 'mandrill'
      m = mandrill = Mandrill::API.new ENV['MANDRILL_APIKEY']
      message = {  
       :subject=> "Hello from the Mandrill API",  
       :from_name=> "Your name",  
       :text=>"Hi message, how are you?",  
       :to=>[  
         {  
           :email=> recipient.to_s,
           :name=> "Recipient1"  
         }  
       ],  
       :html=>"<html><h1>Hi <strong>message</strong>, how are you?</h1></html>",  
       :from_email=>"sender@yourdomain.com"  
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