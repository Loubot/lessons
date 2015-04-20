class TeacherMailer < ActionMailer::Base
  include Devise::Mailers::Helpers
  def mail_teacher(student, student_name, teacher, start_time, end_time)
    p 'test mail start'

    p "start time #{start_time} end time #{end_time}"

    startTime = start_time
    endTime = end_time
    begin
      require 'mandrill'
      m = mandrill = Mandrill::API.new ENV['MANDRILL_APIKEY']
      message = {  
       :subject=> "You have a booking",  
       :from_name=> "Learn Your Lesson",  
       :text=> %Q(<html>#{student_name} has booked a lesson.
                #{startTime} to #{endTime}</html>),  
       :to=>[  
         {  
           :email=> teacher.to_s,
           :name=> "#{student_name}"  
         }  
       ],  
       :html=> %Q(<html>#{student_name} has booked a lesson.
                #{startTime} to #{endTime}</html>),  
       :from_email=> student.to_s  
      }  
      sending = m.messages.send message  
      puts sending
    rescue Mandrill::Error => e
        # Mandrill errors are thrown as exceptions
        logger.info "A mandrill error occurred: #{e.class} - #{e.message}"
        # A mandrill error occurred: Mandrill::UnknownSubaccountError - No subaccount exists with the id 'customer-123'    
    raise
    end

    logger.info "Mail sent to #{teacher.to_s}"
  end

  def home_booking_stripe_mail(json_response, cart)    
    begin
      require 'mandrill'
      m = mandrill = Mandrill::API.new ENV['MANDRILL_APIKEY']
      message = {  
       :subject=> "You have a booking request",  
       :from_name=> "Learn Your Lesson",  
       :text=> %Q(<html>#{cart.student_name} has requested a lesson.
                #{cart.student_name} would like to book a lesson at their own house.
                Their address is #{cart.address}. Please contact them via email to arrange a time.),  
       :to=>[  
         {  
           :email=> cart.teacher_email,
           :name=> "#{cart.student_email}"  
         }  
       ],  
       :html=> %Q(<html>#{cart.student_name} has requested a lesson.
                #{cart.student_name} would like to book a lesson at their own house.
                Their address is #{cart.address}. Please contact them via email to arrange a time.),  
       :from_email=> cart.student_email 
      }  
      sending = m.messages.send message  
      puts sending
    rescue Mandrill::Error => e
        # Mandrill errors are thrown as exceptions
        logger.info "A mandrill error occurred: #{e.class} - #{e.message}"
        # A mandrill error occurred: Mandrill::UnknownSubaccountError - No subaccount exists with the id 'customer-123'    
    raise
    end

    logger.info "Mail sent to #{cart.teacher_email}"

  end

  def paypal_package_email(student, student_name, teacher)
    begin
      require 'mandrill'
      m = mandrill = Mandrill::API.new ENV['MANDRILL_APIKEY']
      message = {  
       :subject=> "You sold a package",  
       :from_name=> "Learn Your Lesson",  
       :text=> %Q(<html>#{student_name} has purchased a package.
                ),  
       :to=>[  
         {  
           :email=> cart.teacher_email,
           :name=> "#{cart.student_email}"  
         }  
       ],  
       :html=> %Q(<html>#{cart.student_name} has requested a lesson.
                #{cart.student_name} would like to book a lesson at their own house.
                Their address is #{cart.address}. Please contact them via email to arrange a time.),  
       :from_email=> cart.student_email 
      }  
      sending = m.messages.send message  
      puts sending
    rescue Mandrill::Error => e
        # Mandrill errors are thrown as exceptions
        logger.info "A mandrill error occurred: #{e.class} - #{e.message}"
        # A mandrill error occurred: Mandrill::UnknownSubaccountError - No subaccount exists with the id 'customer-123'    
    raise
    end

    logger.info "Mail sent to #{cart.teacher_email}"
  end

  

  def reset_password_instructions(record, token, opts={})
    puts "record: #{record.first_name} token: #{token} opts: #{opts}  #{:reset_password_instructions}"
    @token = token    
    #devise_mail(record, :reset_password_instructions, opts)
    begin
      require 'mandrill'
      m = mandrill = Mandrill::API.new ENV['MANDRILL_APIKEY']
      message = {  
       :subject=> "Password reset",  
       :from_name=> "Learn Your Lesson",  
       :text=> %Q(<html>Reset your password #{record} #{token} #{opts} <br>

                <a>https://learn-your-lesson.herokuapp.com/teachers/password/edit?reset_password_token=#{token}</a></html>),  
       :to=>[  
         {  
           :email=> record.email,
           :name=> "#{record.full_name}"  
         }  
       ],  
       :html=> %Q(<html>http://localhost:3000/teachers/password/edit?reset_password_token=#{token}</html>),  
       :from_email=> "learn@b.com"  
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