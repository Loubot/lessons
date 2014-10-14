class TeacherMailer < ActionMailer::Base

  def test_mail(student, student_name, teacher, start_time, end_time)

    begin
      require 'mandrill'
      m = mandrill = Mandrill::API.new ENV['MANDRILL_APIKEY']
      message = {  
       :subject=> "You have a booking",  
       :from_name=> "Learn Your Lesson",  
       :text=>"#{student_name} has booked a lesson.
                #{start_time} to #{end_time}",  
       :to=>[  
         {  
           :email=> teacher.to_s,
           :name=> "#{student_name}"  
         }  
       ],  
       :html=>"<html>#{student_name} has booked a lesson.
                #{start_time} to #{end_time}</html>",  
       :from_email=>"admin@learn-your-lesson.ie"  
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