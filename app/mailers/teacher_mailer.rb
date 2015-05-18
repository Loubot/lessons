class TeacherMailer < ActionMailer::Base
  include ActionView::Helpers::NumberHelper
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

  def home_booking_mail_student(cart)

    begin
      require 'mandrill'
      
      mandrill = Mandrill::API.new ENV['MANDRILL_APIKEY']
      template_name = "students-home-booking-to-student"
      template_content = []
      message = { 
                  subject: "Confirmation of booking request",     
                  :to=>[  
                   {  
                     :email=> cart.student_email.to_s
                     # :name=> "#{student_name}"  
                   }  
                 ],  
                 :from_email=> "loubot@learnyourlesson.ie",
                "merge_vars"=>[
                              { "rcpt"   =>  cart.student_email,
                                "vars" =>  [
                                          { "name"=>"FNAME",          "content"=>cart.student_name  },
                                          { "name"=>"TNAME",          "content"=>cart.teacher_name  },
                                          { "name"=>"TEMAILADDRESS",  "content"=>cart.teacher_email },
                                          { "name"=>"LESSONPRICE",    "content"=>number_to_currency(cart.amount, unit:'€') },
                                          { "name"=>"LESSONLOCATION", "content"=>cart.address }
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

    logger.info "home_booking_mail_student #{cart.student_email}"

  end #end of home_booking_mail_student


  def home_booking_mail_teacher(cart)

    begin
      require 'mandrill'
      
      mandrill = Mandrill::API.new ENV['MANDRILL_APIKEY']
      template_name = "students-home-booking-to-teacher"
      template_content = []
      message = { 
                  subject: "Confirmation of booking request",     
                  :to=>[  
                   {  
                     :email=> cart.teacher_email
                     # :name=> "#{student_name}"  
                   }  
                 ],  
                 :from_email=> "loubot@learnyourlesson.ie",
                "merge_vars"=>[
                              { "rcpt"   =>  cart.teacher_email,
                                "vars" =>  [
                                          { "name"=>"FNAME",          "content"=>cart.teacher_name  },
                                          { "name"=>"SNAME",          "content"=>cart.student_name   },
                                          { "name"=>"STEMAILADDRESS", "content"=>cart.student_email  },
                                          { "name"=>"LESSONPRICE",    "content"=>number_to_currency(cart.amount, unit:'€') },
                                          { "name"=>"LESSONLOCATION", "content"=>cart.address }
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

    logger.info "home_booking_mail_teacher #{cart.teacher_email}"

  end #end of home_booking_mail_student

  def paypal_package_email(student_email, student_name, teacher_email, package)
    begin
      require 'mandrill'
      m = mandrill = Mandrill::API.new ENV['MANDRILL_APIKEY']
      message = {  
       :subject=> "You sold a package",  
       :from_name=> "Learn Your Lesson",  
       :text=> %Q(<html>#{student_name} has purchased a package.
                  "#{package.no_of_lessons}x#{package.subject_name} lessons".
                  Please contact them at #{student_email} to arrange a lesson.
                ),  
       :to=>[  
         {  
           :email=> teacher_email,
           :name=> "#{student_email}"  
         }  
       ],  
       :html=> %Q(<html>#{student_name} has purchased a package.
                  "#{package.no_of_lessons}x#{package.subject_name} lessons".
                  Please contact them at #{student_email} to arrange a lesson.
                ),  
       :from_email=> student_email 
      }  
      sending = m.messages.send message  
      puts sending
    rescue Mandrill::Error => e
        # Mandrill errors are thrown as exceptions
        logger.info "A mandrill error occurred: #{e.class} - #{e.message}"
        # A mandrill error occurred: Mandrill::UnknownSubaccountError - No subaccount exists with the id 'customer-123'    
    raise
    end

    logger.info "Mail sent to #{teacher_email}"
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