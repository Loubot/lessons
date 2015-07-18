require 'rails_helper'
require 'database_cleaner'

# describe 'try to select a subject' do

# 	it 'should select a subject' do
# 		category = build(:category)
# 		subject = build(:subject)
		
# 		fill_in 'teachers_search_input', with: 'Drums'
# 		click_link_or_button('add_subject_to_teacher')
# 		expect(page).to have_content('Drums')
# 		expect(current_path).to eq(edit_teacher_path)
		

# 	end
# end

describe 'posts for teacher info' do

	it 'should have teachers info' do
		teacher = FactoryGirl.create(:teacher)
		login_as(teacher, scope: :teacher)
		visit 'teachers/1/edit'
		expect(page).to have_content(teacher.first_name)
	end

	it 'should update teachers names' do
		teacher = FactoryGirl.create(:teacher)
		login_as(teacher, scope: :teacher)
		visit 'teachers/1/edit'
		fill_in 'teacher_first_name', with: 'Louballs'
		fill_in 'teacher_last_name', with: 'Nancypoo'
		click_link_or_button('teacher_names_submit')
		expect(page).to have_content 'Louballs'
		expect(page).to have_content 'Nancypoo'
	end
end

describe 'posts for  experience' do

	before (:each) do 
		DatabaseCleaner.strategy = :truncation

		# then, whenever you need to clean the DB
		DatabaseCleaner.clean
		teacher = FactoryGirl.create(:teacher)
		login_as(teacher, scope: :teacher)
	end

	it 'should update users experience' do
		visit '/teachers/1/edit'
		expect(page).to have_content('Your profile is not visible')
		# click_link_or_button('teachers_experience_modal_button')
		
		fill_in 'experience_title', with: 'Piano player'
		fill_in 'experience_description', with: 'Been playing piano for years'
		select "2007", from: "experience[start(1i)]"
		select "July", from: "experience[start(2i)]"
		find(:css, "#visible_check").set(true)
			
		
		click_link_or_button('experience_submit')
		expect(current_path).to eq(edit_teacher_path(id: 1))
		expect(page).to have_content('Work experience saved')

	end

	it "should fail if dates are incorrect" do
		visit '/teachers/1/edit'
		
		fill_in 'experience_title', with: 'Piano player'
		fill_in 'experience_description', with: 'Been playing piano for years'
		select "2015", from: "experience[start(1i)]"
		select "July", from: "experience[start(2i)]"
		select "2007", from: "experience[end_time(1i)]"
		select "July", from: "experience[end_time(2i)]"			
		
		click_link_or_button('experience_submit')
		expect(page).to have_content("Couldn't save your work experience")
	end

end

describe 'posts for overview' do
	before (:each) do 
		DatabaseCleaner.strategy = :truncation

		# then, whenever you need to clean the DB
		DatabaseCleaner.clean
		teacher = FactoryGirl.create(:teacher)
		login_as(teacher, scope: :teacher)
	end

	it "should not have overview" do
		visit 'teachers/1/edit'
		expect(page).to have_no_content('I is a teacher')
	end

	it 'should upldate teachers overview' do
		visit 'teachers/1/edit'
		expect(page).to have_content('Photos of you')

		fill_in 'teacher_overview', with: 'I is a teacher'
		click_link_or_button('teacher_overview_submit')
		expect(page).to have_content('I is a teacher')
	end

end