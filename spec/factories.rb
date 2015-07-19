FactoryGirl.define do

	sequence :email do |n|
    "email#{n}@factory.com"
  end

	factory :teacher do
		first_name 					'Louis'
		last_name 					'Angelini'
		email 							
		password						'password'
		profile_views				1
		is_teacher					true
		admin								true
	end

	factory :category do 
		name 'Music'
	end

	factory :subject do
		name 'Drums'
		category
		
	end

	factory :qualification do
		title				'Piano Player'
		school			'UCC'
		start				Time.now - 5.years
		end_time		Time.now
		teacher
	end

end