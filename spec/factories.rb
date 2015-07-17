FactoryGirl.define do

	factory :teacher do
		first_name 					'Louis'
		last_name 					'Angelini'
		email 							'test@balls.com'
		profile_views				1
		is_teacher					true
		admin								true
	end
end