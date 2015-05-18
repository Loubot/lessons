task :check_subscriptions => :environment do
  # Teacher.where(is_teacher: true).where("paid_up_date < ?", 5.days.ago).each do |t|
  teachers = Teacher.where(email: ["lllouis@yahoo.com", "alan.rowell28@googlemail.com"])
  teachers.each do |t|  
   	if t.paid_up_date < 5.days.ago
    	MembershipMailer.delay.pay_up_time(t.email)
    end
  end
end

