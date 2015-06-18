class MembershipMailer < ActionMailer::Base
  include Devise::Mailers::Helpers
  include ActionView::Helpers::UrlHelper


  def membership_paid(teacher_email, teacher_name)
    p 'membership_paid mail start'    
    begin
      require 'mandrill'
      mandrill = Mandrill::API.new ENV['MANDRILL_APIKEY']
      template_name = "membership-template"
      template_content = []
      message = { 
                  subject: "You have paid!",     
                  :to=>[  
                   {  
                     :email=> teacher_email.to_s
                     # :name=> "#{student_name}"  
                   }  
                 ],  
                 :from_email=> "loubot@learnyourlesson.ie",
                 "merge_vars"=>
                         [{"rcpt"   =>  teacher_email,
                             "vars" =>  [{ "name"=>"FULLNAME", 
                                        "content"=>teacher_name 
                                      }]
                          }],
                  
                }
      async = false
      result = mandrill.messages.send_template template_name, template_content, message, async
      # sending = m.messages.send message  
      puts result
      
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

  def send_invite_to_teacher(email, invitation, url)
    p "url #{link_to('Accept', url)}"
    begin
      require 'mandrill'
      m = mandrill = Mandrill::API.new ENV['MANDRILL_APIKEY']
      message = {  
       :subject=> "You are invited to join Learn Your lesson",  
       :from_name=> "#{invitation.inviter_name}",  
       :text=> "#{invitation.inviter_name} has invited you to join our team. Click the link below to register and get started. #{link_to('Accept', url)}",  
       :to=>[  
         {  
           :email=> invitation.recipient_email
           # :name=> "#{student_name}"  
         }  
       ],  
       :html=> "#{invitation.inviter_name} has invited you to join our team. Click the link below to register and get started. #{link_to('Accept', url)}",  
       :from_email=> "loubot@learnyourlesson.ie",
       async: false 
      }  
      sending = m.messages.send message  
      puts sending
    rescue Mandrill::Error => e
        # Mandrill errors are thrown as exceptions
        logger.info "A mandrill error occurred: #{e.class} - #{e.message}"
        # A mandrill error occurred: Mandrill::UnknownSubaccountError - No subaccount exists with the id 'customer-123'    
    raise
    end

    logger.info "Mail sent to #{email}"
  end

  def send_invite_to_student(teacher, student_email)
    p 'Sending invitation to student'    
    begin
      require 'mandrill'
      mandrill = Mandrill::API.new ENV['MANDRILL_APIKEY']
      template_name = "invite-teacher-to-student"
      template_content = []
      message = { 
                  :subject => "You've been invited to Learn Your Lesson by #{teacher.first_name}",
                  :to=>[  
                   {  
                     :email=> student_email
                     # :name=> "#{student_name}"  
                   }  
                 ],  
                 :from_email=> "alan@learnyourlesson.ie",
                 :from_name=> "LYL",
                 "merge_vars"=>
                         [{"rcpt"   =>  student_email,
                             "vars" =>  [
                                      { "name"=>"INVITERNAME", "content"=>teacher.first_name.pluralize },
                                      { "name"=>"TEACHERSURL", "content"=> "http://localhost:3000/show-teacher?id=#{teacher.id}" }
                                      ]
                          }],
                  
                }
      async = false
      result = mandrill.messages.send_template template_name, template_content, message, async
      # sending = m.messages.send message  
      puts result
      
    rescue Mandrill::Error => e
        # Mandrill errors are thrown as exceptions
        logger.info "A mandrill error occurred: #{e.class} - #{e.message}"
        # A mandrill error occurred: Mandrill::UnknownSubaccountError - No subaccount exists with the id 'customer-123'    
    raise
    end

    logger.info "Mail sent to #{student_email}"
  end
end