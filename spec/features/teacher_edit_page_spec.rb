require 'rails_helper'
require 'database_cleaner'


# describe 'try to select a subject', js: true do
# 	before (:each) do 
# 		DatabaseCleaner.strategy = :truncation

# 		DatabaseCleaner.clean
# 		Capybara.current_driver = :selenium
# 		@teacher = FactoryGirl.create(:teacher)
# 		login_as(@teacher, scope: :teacher, :run_callbacks => false)	
# 	end

# 	it "shouldn't be valid" do

# 		visit 'http://localhost:3000/teachers/1/edit'
		
# 		expect(page).to have_content "Your info"
		
# 	end
# end

# describe 'posts for teacher info' do
# 	before (:each) do 
# 		DatabaseCleaner.strategy = :truncation

# 		DatabaseCleaner.clean
# 		@teacher = FactoryGirl.create(:teacher)

# 		login_as(@teacher, scope: :teacher)

# 	end

# 	it 'should have teachers info' do
# 		visit 'teachers/1/edit'
# 		expect(page).to have_content(@teacher.first_name)
# 	end

# 	it 'should update teachers names' do
# 		visit 'teachers/1/edit'
# 		fill_in 'teacher_first_name', with: 'Louballs'
# 		fill_in 'teacher_last_name', with: 'Nancypoo'
# 		click_link_or_button('teacher_names_submit')
# 		expect(page).to have_content 'Louballs'
# 		expect(page).to have_content 'Nancypoo'
# 	end
# end

# webkit driver
describe 'test photo uploads', js: true do 
	before (:each) do 
		DatabaseCleaner.strategy = :truncation
		Capybara.current_driver = :selenium
		# then, whenever you need to clean the DB
		DatabaseCleaner.clean
		@teacher = FactoryGirl.create(:teacher)

		login_as(@teacher, scope: :teacher)
		
	end

	it "should visit edit page ok" do
		visit edit_teacher_path(@teacher)
		expect(page).to have_content('Your info')
	end




	# it "should upload a photo", js: true do
	# 	# @teacher = FactoryGirl.create(:teacher)
	# 	# login_as @teacher, scope: :teacher
	# 	# # p "current_teacher #{subject.current_teaecher}"
	# 	p "teacher 1 #{@teacher.inspect}"
	# 	# visit "teachers/#{@teacher.id}/edit"
	# 	# page.driver.allow_url(*
	# 	# page.execute_script("document.getElementById('dropzone').appendChild('<input id=\"picture_upload_field\" name=\"image\" type=\"file\">')")
	# 	page.attach_file('dropzone', '/home/loubot/Pictures/Webcam/me.jpg')
	# 	click_link_or_button('process_queue')
	# 	# sleep 5
	# 	expect(page).to have_content('Your info')
	# end
end

describe "when user drop files", :js => true do
  before do
     files = [ Rails.root + 'spec/support/me.jpg' ]
     p "files #{files}"
     drop_files files, 'dropzone'
  end

  it "should ..." do
     should have_content '...'
  end
end   

# describe 'posts for  experience' do

# 	before (:each) do 
# 		DatabaseCleaner.strategy = :truncation

# 		# then, whenever you need to clean the DB
# 		DatabaseCleaner.clean
# 		Capybara.current_driver = :webkit

# 		teacher = FactoryGirl.create(:teacher)
# 		login_as(teacher, scope: :teacher)
# 	end

# 	it 'should update users experience' do
# 		visit '/teachers/1/edit'
# 		expect(page).to have_content('Your profile is not visible')
# 		# click_link_or_button('teachers_experience_modal_button')
		
# 		fill_in 'experience_title', with: 'Piano player'
# 		fill_in 'experience_description', with: 'Been playing piano for years'
# 		select "2007", from: "experience[start(1i)]"
# 		select "July", from: "experience[start(2i)]"
# 		find(:css, "#visible_check").set(true)
			
		
# 		click_link_or_button('experience_submit')
# 		expect(current_path).to eq(edit_teacher_path(id: 1))
# 		expect(page).to have_content('Work experience saved')
# 		expect(page).to have_content('Been playing piano for years')
# 		expect(page).to have_content('2007')

# 	end

# 	it "should fail if dates are incorrect" do
# 		visit '/teachers/1/edit'
		
# 		fill_in 'experience_title', with: 'Piano player'
# 		fill_in 'experience_description', with: 'Been playing piano for years'
# 		select "2015", from: "experience[start(1i)]"
# 		select "July", from: "experience[start(2i)]"
# 		select "2007", from: "experience[end_time(1i)]"
# 		select "July", from: "experience[end_time(2i)]"			
		
# 		click_link_or_button('experience_submit')
# 		expect(page).to have_content("Couldn't save your work experience")
# 	end

# end

# describe 'posts for overview' do
# 	before (:each) do 
# 		DatabaseCleaner.strategy = :truncation

# 		# then, whenever you need to clean the DB
# 		DatabaseCleaner.clean
# 		teacher = FactoryGirl.create(:teacher)
# 		login_as(teacher, scope: :teacher)
# 	end

# 	it "should not have overview" do
# 		visit 'teachers/1/edit'
# 		expect(page).to have_no_content('I is a teacher')
# 	end

# 	it 'should upldate teachers overview' do
# 		visit 'teachers/1/edit'
# 		expect(page).to have_content('Photos of you')

# 		fill_in 'teacher_overview', with: 'I is a teacher'
# 		click_link_or_button('teacher_overview_submit')
# 		expect(page).to have_content('I is a teacher')
# 	end

# end

#webkit driver

# describe "get stripe key" do 
# 	it "should add get stripe added succesfully message " do
# 		DatabaseCleaner.strategy = :truncation

# 		# then, whenever you need to clean the DB
# 		DatabaseCleaner.clean
# 		teacher = FactoryGirl.create(:teacher)
# 		login_as(teacher, scope: :teacher)

# 		visit 'teachers/1/edit'
# 		click_link_or_button('stripe_connect_button')
# 		expect(page).to have_content('Successfully registered with Stripe. Stripe code updated')
# 	end
# end

# describe "set paypal email" do
# 	before (:each) do 
# 		DatabaseCleaner.strategy = :truncation

# 		# then, whenever you need to clean the DB
# 		DatabaseCleaner.clean
# 		teacher = FactoryGirl.create(:teacher)
# 		login_as(teacher, scope: :teacher)
# 	end

# 	it "should fail with incorrect email" do
# 		visit 'teachers/1/edit'
# 		page.fill_in 'teacher_paypal_first_name', with: 'Louis'
# 		page.fill_in 'teacher_paypal_last_name', with: 'Angelini'
# 		page.fill_in 'teacher_paypal_email', with: 'llslouis@yahoo.com'
# 		click_link_or_button('teacher_paypal_confirm_button')
# 		expect(page).to have_content('Email or names provided incorrect or not a paypal merchant account.')

# 	end

# 	it "should fail with incorrect first name" do
# 		visit 'teachers/1/edit'
# 		page.fill_in 'teacher_paypal_first_name', with: 'Louiss'
# 		page.fill_in 'teacher_paypal_last_name', with: 'Angelini'
# 		page.fill_in 'teacher_paypal_email', with: 'llslouis@yahoo.com'
# 		click_link_or_button('teacher_paypal_confirm_button')
# 		expect(page).to have_content('Email or names provided incorrect or not a paypal merchant account.')

# 	end

# 	it "should fail with incorrect last name" do
# 		visit 'teachers/1/edit'
# 		page.fill_in 'teacher_paypal_first_name', with: 'Louis'
# 		page.fill_in 'teacher_paypal_last_name', with: 'Angelinis'
# 		page.fill_in 'teacher_paypal_email', with: 'llslouis@yahoo.com'
# 		click_link_or_button('teacher_paypal_confirm_button')
# 		expect(page).to have_content('Email or names provided incorrect or not a paypal merchant account.')

# 	end

# 	it "should respond with success with correct credentials" do
# 		visit 'teachers/1/edit'
# 		page.fill_in 'teacher_paypal_first_name', with: 'Louis'
# 		page.fill_in 'teacher_paypal_last_name', with: 'Angelini'
# 		page.fill_in 'teacher_paypal_email', with: 'lllouis@yahoo.com'
# 		click_link_or_button('teacher_paypal_confirm_button')
# 		expect(page).to have_content('Paypal email updated ok')
# 	end
# end #end of set paypal email


# describe "adding authentications" do
# 	before (:each) do 
# 		DatabaseCleaner.strategy = :truncation

# 		# then, whenever you need to clean the DB
# 		DatabaseCleaner.clean
# 		teacher = FactoryGirl.create(:teacher)
# 		login_as(teacher, scope: :teacher)
# 	end

# 	it "should add facebook" do
# 		visit 'teachers/1/edit'
		
#    	click_link_or_button('facebook_login_link')
#    	expect(page).to have_content('Facebook added to login methods.')
#    	expect(current_path).to eq('/teachers/1/edit')
# 	end

# 	it "should add google" do
# 		visit 'teachers/1/edit'

# 		click_link_or_button('google_oauth2_login_link')
# 		expect(page).to have_content('Google added to login methods.')
# 		expect(current_path).to eq('/teachers/1/edit')
# 	end

# 	it "should add twtitter" do
# 		visit 'teachers/1/edit'

# 		click_link_or_button('twitter_login_link')
# 		expect(page).to have_content('Twitter added to login methods.')
# 		expect(current_path).to eq('/teachers/1/edit')
# 	end

# 	it "should add linkedin" do
# 		visit 'teachers/1/edit'

# 		click_link_or_button('linkedin_login_link')
# 		expect(page).to have_content("Linkedin added to login methods.")
# 		expect(current_path).to eq('/teachers/1/edit')
# 	end
# end
