class AdminMailer < ActionMailer::Base

  def send_feedback_email(params)
    begin
      require 'mandrill'
      m = mandrill = Mandrill::API.new ENV['MANDRILL_APIKEY']
      message = {  
       :subject=> params[:subject],  
       :from_name=> params[:name],
       :from_email => "do-not-reply@learnyourlesson.ie",
       :text => "From: " + params[:email] + " Message " + params['feedback-info'],
       :to=>[
          {
            :email => "louisangelini@gmail.com",
            :name => "Admin"
          }, 
          {
            :email => 'alan@learnyourlesson.ie',
            :name => 'Admin'
          },
         {  
           :email=> 'loubot@learnyourlesson.ie',
           :name=> 'Admin' 
         }  
       ],  
       :html=> "From: <br>" + params[:email] + "<br>Message:<br> " + params['feedback-info'],  
       # :from_email=> params[:emal]  
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

  def user_registered(user)
    begin
      require 'mandrill'
      m = mandrill = Mandrill::API.new ENV['MANDRILL_APIKEY']
      message = {  
       :subject=> "New User",  
       :from_name=> 'Admin',
       :from_email => 'do-not-reply@learnyourlesson.ie',
       :text=> %Q(#{user.email} has registered @ #{Time.now}),  
       :to=>[  
          {
            :email => 'philip@learnyourlesson.ie',
            :name => 'Admin'
          },
          {
            email: 'philipmngadi@gmail.com',
            name: 'Admin'
          },
          {
            email: 'louisangelini@gmail.com',
            name: 'Admin'
          },
          {
            email: 'turquoisecathy@gmail.com',
            name: 'Admin'
          },
          {
            email: 'alan.rowell28@googlemail.com',
            name: 'Admin'
          }
       ],  
       
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