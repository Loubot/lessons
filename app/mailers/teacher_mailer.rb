class TeacherMailer < ActionMailer::Base
  include ActionView::Helpers::NumberHelper
  include Devise::Mailers::Helpers

  def single_booking_mail_teacher(lesson_location, cart)
    # logger.info "teacher email email #{student_name} #{params} #{student_name}"
    begin
      weeks = cart.weeks.to_i
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
                                          { "name"=>"NUMBERLESSONS",  "content"=>weeks },
                                          { "name"=>"LESSONPRICE",    "content"=>number_to_currency(cart.amount * weeks, unit: '€') },
                                          { "name"=>"LESSONTIME",     "content"=>cart.params[:start_time].strftime("%H:%M") },
                                          { "name"=>"LESSONDATE",     "content"=>cart.params[:start_time].strftime("%d %b %Y") },
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

  def single_booking_mail_student(lesson_location, cart)
    
    begin
      weeks = cart.weeks.to_i
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
                                          { "name"=>"NUMBERLESSONS",  "content"=>weeks },
                                          { "name"=>"LESSONPRICE",    "content"=>number_to_currency(cart.amount * weeks, unit: '€') },
                                          { "name"=>"LESSONTIME",     "content"=>cart.params[:start_time].strftime("%H:%M") },
                                          { "name"=>"LESSONDATE",     "content"=>cart.params[:start_time].strftime("%d %b %Y") },
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
                                          { "name"=>"LESSONPRICE",    "content"=>number_to_currency(cart.amount, unit:'€') },
                                          { "name"=>"NUMBERLESSONS",  "content"=>1 },
                                          { "name"=>"LESSONLOCATION", "content"=>cart.address },
                                          { "name"=>"LESSONTIME",     "content"=>cart.params[:start_time].strftime("%H:%M") },
                                          { "name"=>"LESSONDATE",     "content"=>cart.params[:start_time].strftime('%d/%m/%Y') }
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
    # p "date $$$$$$$$$$$$$$ #{cart.params[:date].to_date}"
    # logger.info "date $$$$$$$$$$$$$$ #{cart.params[:date].to_date}"
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
                                          { "name"=>"LESSONTIME",     "content"=>cart.params[:start_time].strftime("%H:%M") },
                                          { "name"=>"LESSONDATE",     "content"=>cart.params[:start_time].strftime('%d/%m/%Y') },
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

  def package_email_teacher(cart, package)
    begin
      require 'mandrill'
      
      mandrill = Mandrill::API.new ENV['MANDRILL_APIKEY']
      template_name = "package-booking-to-teacher"
      template_content = []
      message = { 
                  subject: "You've sold a package",     
                  :to=>[  
                   {  
                     :email=> cart.teacher_email
                     # :name=> "#{student_name}"  
                   }  
                 ],  
                 :from_email=> "alan@learnyourlesson.ie",
                "merge_vars"=>[
                              { "rcpt"   =>  cart.teacher_email,
                                "vars" =>  [
                                          { "name"=>"FNAME",            "content"=>cart.teacher_name  },
                                          { "name"=>"SNAME",            "content"=>cart.student_name  },
                                          { "name"=>"STEMAILADDRESS",  "content"=>cart.student_email  },
                                          { "name"=>"LESSONPRICE",      "content"=>number_to_currency(package.price, unit:'€') },
                                          { "name"=>"NUMBERLESSONS",    "content"=>package.no_of_lessons }
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
  end

  def package_email_student(cart, package)
    begin
      require 'mandrill'
      
      mandrill = Mandrill::API.new ENV['MANDRILL_APIKEY']
      template_name = "package-booking-to-student"
      template_content = []
      message = { 
                  subject: "You've booked a package",     
                  :to=>[  
                   {  
                     :email=> cart.student_email
                     # :name=> "#{student_name}"  
                   }  
                 ],  
                 :from_email=> "alan@learnyourlesson.ie",
                "merge_vars"=>[
                              { "rcpt"   =>  cart.student_email,
                                "vars" =>  [
                                          { "name"=>"FNAME",            "content"=>cart.student_name  },
                                          { "name"=>"TNAME",            "content"=>cart.teacher_email  },
                                          { "name"=>"TEMAILADDRESS",   "content"=>cart.student_email  },
                                          { "name"=>"LESSONPRICE",      "content"=>number_to_currency(package.price, unit:'€') },
                                          { "name"=>"NUMBERLESSONS",    "content"=>package.no_of_lessons }
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

  def teacher_to_student_mail(student, teacher, subject, message)
    begin
      require 'mandrill'
      mandrill = Mandrill::API.new ENV['MANDRILL_APIKEY']
      message = {
        subject: subject,
        to: [
          {
            email: student
          }
        ],
        from_email: teacher,
        text: message
      }
      async = false
      result = mandrill.messages.send message, async
    rescue Mandrill::Error => e
      puts "A mandrill error occurred: #{e.class} - #{e.message}"
    end

  end

end