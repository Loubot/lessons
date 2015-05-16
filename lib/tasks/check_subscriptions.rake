task :check_subscriptions => :environment do
  Teacher.where(is_teacher: true).where("paid_up_date < ?", 5.days.ago).each do |t|
   
    MembershipMailer.pay_up_time(t.email).deliver_now
    
  end
  

end