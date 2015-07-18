FactoryGirl.define do

	factory :teacher do
		first_name 					'Louis'
		last_name 					'Angelini'
		email 							'test@balls.com'
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

end