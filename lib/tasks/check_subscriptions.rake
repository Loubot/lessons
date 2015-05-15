task :print_teachers => :environment do
  Teacher.where(is_teacher: true).each do |t|
    if 5.day.ago > t.paid_up_date
      p "hello"
    end
  end
end