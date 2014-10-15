class TeacherMailer < ActionMailer::Base

  def test_mail(student, student_name, teacher, start_time, end_time)

    begin
      require 'mandrill'
      m = mandrill = Mandrill::API.new ENV['MANDRILL_APIKEY']
      message = {  
       :subject=> "You have a booking",  
       :from_name=> "Learn Your Lesson",  
       :text=> %Q(<html>#{student_name} has booked a lesson.
                #{start_time.strftime("%d/%b/%y @%H:%M")} to #{end_time.strftime("%d/%b/%y @%H:%M")}</html>),  
       :to=>[  
         {  
           :email=> teacher.to_s,
           :name=> "#{student_name}"  
         }  
       ],  
       :html=> %Q(<html>#{student_name} has booked a lesson.
                #{start_time.strftime("%d/%b/%y @%H:%M")} to #{end_time.strftime("%d/%b/%y @%H:%M")}</html>),  
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
  end
end