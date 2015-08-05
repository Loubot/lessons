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
	  trait :complete do
	  	profile 					1
	  	overview 					'I is a teacher'
	  	
	  end
	end

	factory :category do 
		name 'Music'
	end	

	factory :location do
		teacher_id 				1
		latitude					4.2
		longitude					4.2
		name 							'Home'
		address 					'49 Beech Park'
	end

	factory :photo do
		name 							nil
		imageable_id 			1
		imageable_type 		"Teacher"
		avatar 						"fake_text.jpg"
	end

	factory :price do
		subject_id				1
		teacher
		price 						33.4
		duration					45
	end

	factory :subject do
		name 							'Bass'
		category_id				1
		# category
	end

	factory :experience do
		teacher_id 				1
		title 				"Drum player"
		description		"I is a drum player"
		teacher
		start 				Time.now - 5.years
		end_time			Time.now
		present 			1
	end

	factory :event do
		title 						'Louis'
		start_time				3.days.ago - 1.hours
		end_time					3.days.ago
		teacher_id 				1
	end	

	factory :qualification do
		title				'Piano Player'
		school			'UCC'
		start				Time.now - 5.years
		end_time		Time.now
		teacher
	end

end