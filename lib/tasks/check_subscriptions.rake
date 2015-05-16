task :check_subscriptions => :environment do
  Teacher.where(is_teacher: true).each do |t|
    if 5.day.ago > t.paid_up_date
      MembershipMailer.pay_up_time(t.email).deliver_now
    end
  end

end