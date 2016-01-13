FactoryGirl.define do  factory :message do
    message "MyText"
conversation_id 1
  end
  factory :conversation do
    teacher 1
student 1
student_email "MyString"
student_email "MyString"
message "MyText"
  end


	sequence :email do |n|
    "email#{n}@factory.com"
  end

	factory :teacher do
		first_name 					'Louis'
		last_name 					'Angelini'
		email
		profile 						1 							
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
		name 							'hello'
		imageable_id 			1
		imageable_type 		"Teacher"
		
		avatar 						{ Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec', 'support', 'me.jpg')) }
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
		teacher_id 				1
		title							'Piano Player'
		school						'UCC'
		start							Time.now - 5.years
		end_time					Time.now
	end

end