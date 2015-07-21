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
		trait :admin do
	    admin true
	    
	  end
	end

	factory :category do 
		name 'Music'
	end

	factory :subject do
		name 'Drums'
		category
		
	end

	factory :location do
		teacher_id 				1
		latitude					4.2
		longitude					4.2
		name 							'Home'
		address 					'49 Beech Park'
	end

	factory :qualification do
		title				'Piano Player'
		school			'UCC'
		start				Time.now - 5.years
		end_time		Time.now
		teacher
	end

end