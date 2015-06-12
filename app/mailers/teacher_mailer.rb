class TeacherMailer < ActionMailer::Base
  include ActionView::Helpers::NumberHelper
  include Devise::Mailers::Helpers

  def single_booking_mail_teacher(amount, lesson_location, cart)
    # logger.info "teacher email email #{student_name} #{params} #{student_name}"
    begin
      require 'mandrill'
      m = mandrill = Mandrill::API.new ENV['MANDRILL_APIKEY']
      template_name ="teachers-home-booking-to-teacher"
      template_content = []
      message = { 
                  subject: "You have a booking",     
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
                                          { "name"=>"SNAME",          "content"=>cart.student_name  },
                                          { "name"=>"STEMAILADDRESS", "content"=>cart.student_email },
                                          { "name"=>"NUMBERLESSONS",  "content"=>cart.weeks.to_i },
                                          { "name"=>"LESSONPRICE",    "content"=>amount },
                                          { "name"=>"LESSONTIME",     "content"=>cart.params[:start_time].strftime("%H:%M") },
                                          { "name"=>"LESSONDATE",     "content"=>cart.params[:start_time].to_date },
                                          { "name"=>"LESSONLOCATION", "content"=>lesson_location}                                         
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

    logger.info "Mail sent to #{cart.teacher_email}"
  end #end of single_booking_mail_teacher

  def single_booking_mail_student(amount, lesson_location, cart)
    logger.info "teacher email email #{cart.inspect}"
    begin
      require 'mandrill'
      m = mandrill = Mandrill::API.new ENV['MANDRILL_APIKEY']
      template_name ="teachers-home-booking-to-student"
      template_content = []
      message = { 
                  subject: "You have made a booking",
                  :to=>[  
                   {  
                     :email=> cart.student_email  
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
                                          { "name"=>"NUMBERLESSONS",  "content"=>cart.weeks.to_i },
                                          { "name"=>"LESSONPRICE",    "content"=>amount },
                                          { "name"=>"LESSONTIME",     "content"=>cart.params[:start_time].strftime("%H:%M") },
                                          { "name"=>"LESSONDATE",     "content"=>cart.params[:start_time].to_date },
                                          { "name"=>"LESSONLOCATION", "content"=>lesson_location}                                         
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

    logger.info "Mail sent to #{cart.teacher_email}"
  end # end of single_booking_mail_student

  def home_booking_mail_student(params, address, time)

    begin
      require 'mandrill'
      
      mandrill = Mandrill::API.new ENV['MANDRILL_APIKEY']
      template_name = "students-home-booking-to-student"
      template_content = []
      message = { 
                  subject: "Confirmation of booking request",     
                  :to=>[  
                   {  
                     :email=> params['student_email']
                     # :name=> "#{student_name}"  
                   }  
                 ],  
                 :from_email=> "loubot@learnyourlesson.ie",
                "merge_vars"=>[
                              { "rcpt"   =>  params['student_email'],
                                "vars" =>  [
                                          { "name"=>"FNAME",          "content"=>params['student_name']  },
                                          { "name"=>"TNAME",          "content"=>params['teacher_name']  },
                                          { "name"=>"TEMAILADDRESS",  "content"=>params['teacher_email'] },
                                          { "name"=>"LESSONPRICE",    "content"=>number_to_currency(params['amount'], unit:'€') },
                                          { "name"=>"NUMBERLESSONS",  "content"=>1 },
                                          { "name"=>"LESSONLOCATION", "content"=>address },
                                          { "name"=>"LESSONTIME",     "content"=>time },
                                          { "name"=>"LESSONDATE",     "content"=>params['start_time'].to_date }
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

    logger.info "home_booking_mail_student #{params['student_email']}"

  end #end of home_booking_mail_student


  def home_booking_mail_teacher(params, address, time)
    
    begin
      require 'mandrill'
      
      mandrill = Mandrill::API.new ENV['MANDRILL_APIKEY']
      template_name = "students-home-booking-to-teacher"
      template_content = []
      message = { 
                  subject: "Confirmation of booking request",     
                  :to=>[  
                   {  
                     :email=> params['teacher_email']
                     # :name=> "#{student_name}"  
                   }  
                 ],  
                 :from_email=> "loubot@learnyourlesson.ie",
                "merge_vars"=>[
                              { "rcpt"   =>  params['teacher_email'],
                                "vars" =>  [
                                          { "name"=>"FNAME",          "content"=>params['teacher_name']  },
                                          { "name"=>"SNAME",          "content"=>params['student_name']   },
                                          { "name"=>"STEMAILADDRESS", "content"=>params['student_email']  },
                                          { "name"=>"LESSONPRICE",    "content"=>number_to_currency(params['amount'], unit:'€') },
                                          { "name"=>"LESSONTIME",     "content"=>time },
                                          { "name"=>"LESSONDATE",     "content"=>params['start_time'].to_date },
                                          { "name"=>"LESSONLOCATION", "content"=>address }
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

    logger.info "home_booking_mail_teacher #{params['teacher_email']}"

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

  def welcome_mail_teacher(fname, email)
    begin
      require 'mandrill'
      
      mandrill = Mandrill::API.new ENV['MANDRILL_APIKEY']
      template_name = "become-a-teacher-welcome-email"
      template_content = []
      message = { 
                  subject: "Welcome to Learn Your Lesson",     
                  :to=>[  
                   {  
                     :email=> email
                     # :name=> "#{student_name}"  
                   }  
                 ],  
                 :from_email=> "loubot@learnyourlesson.ie",
                "merge_vars"=>[
                              { "rcpt"   =>  email,
                                "vars" =>  [
                                          { "name"=>"FNAME", "content"=>fname  },
                                          
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

    logger.info "welcome email #{email}"
  end

  def welcome_mail_student(fname, email)
    begin
      require 'mandrill'
      
      mandrill = Mandrill::API.new ENV['MANDRILL_APIKEY']
      template_name = "become-a-student-email"
      template_content = []
      message = { 
                  subject: "Welcome to Learn Your Lesson",     
                  :to=>[  
                   {  
                     :email=> email
                     # :name=> "#{student_name}"  
                   }  
                 ],  
                 :from_email=> "loubot@learnyourlesson.ie",
                "merge_vars"=>[
                              { "rcpt"   =>  email,
                                "vars" =>  [
                                          { "name"=>"FNAME", "content"=>fname  },
                                          
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

    logger.info "welcome email #{email}"
  end

end