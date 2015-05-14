task :print_teachers => :environment do
  Teacher.all.each do |t|
    p t.id
  end
end