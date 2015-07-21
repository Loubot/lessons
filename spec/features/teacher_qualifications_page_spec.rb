require 'rails_helper'
require 'database_cleaner'


describe 'posts to qualifications' do
	before (:each) do 
		DatabaseCleaner.strategy = :truncation

		DatabaseCleaner.clean
		teacher = FactoryGirl.create(:teacher)

		login_as(teacher, scope: :teacher)

		visit '/teachers/1/qualification-form'	
	end

	it "shouldn't be valid" do
		
		
		expect(page).to have_content "Qualifications"
		fill_in 'qualification_name', with: ''
		fill_in 'qualification_school', with: 's'
		
		click_link_or_button('qualification_submit')
		expect(page).to have_content('Failed to save qualification')
	end

	it "should fail title validation" do

		fill_in 'qualification_name', with: ''
		fill_in 'qualification_school', with: 'UCC'
		
		click_link_or_button('qualification_submit')
		expect(page).to have_content("Title can't be blank")
	end

	it "should fail school validation" do

		fill_in 'qualification_name', with: 'Degree in Music'
		fill_in 'qualification_school', with: ''
		
		click_link_or_button('qualification_submit')
		expect(page).to have_content("School can't be blank")
	end

	it "should fail date overlap validation" do

		fill_in 'qualification_name', with: 'Degree in Music'
		fill_in 'qualification_school', with: 'UCC'
		select "2015", from: "qualification[start(1i)]"
		select "July", from: "qualification[start(2i)]"
		select "2007", from: "qualification[end_time(1i)]"
		select "July", from: "qualification[end_time(2i)]"
		
		click_link_or_button('qualification_submit')
		expect(page).to have_content('Failed to save qualification ["Start must be after end time"]')
	end

	it 'should create a qualification using correct dates' do

		fill_in 'qualification_name', with: 'Degree in Music'
		fill_in 'qualification_school', with: 'UCC'
		select "2007", from: "qualification[start(1i)]"
		select "July", from: "qualification[start(2i)]"
		select "2015", from: "qualification[end_time(1i)]"
		select "July", from: "qualification[end_time(2i)]"

		click_link_or_button('qualification_submit')
		expect(page).to have_content('Qualification saved')
	end

	it 'should have a qualification' do		
		
		fill_in 'qualification_name', with: 'Degree in Music'
		fill_in 'qualification_school', with: 'UCC'
		select "2007", from: "qualification[start(1i)]"
		select "July", from: "qualification[start(2i)]"
		select "2015", from: "qualification[end_time(1i)]"
		select "July", from: "qualification[end_time(2i)]"

		click_link_or_button('qualification_submit')
		expect(page).to have_content('Delete qualification')
	end

	it 'should delete qualification' do		
		
		fill_in 'qualification_name', with: 'Degree in Music'
		fill_in 'qualification_school', with: 'UCC'
		select "2007", from: "qualification[start(1i)]"
		select "July", from: "qualification[start(2i)]"
		select "2015", from: "qualification[end_time(1i)]"
		select "July", from: "qualification[end_time(2i)]"

		click_link_or_button('qualification_submit')
		click_link_or_button('delete_qualification')
		expect(page).to have_content('Qualification successfully deleted')
	end

end