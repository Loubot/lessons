require 'rails_helper'
require 'database_cleaner'

describe "saving prices common attributes" do
	before (:each) do 
		DatabaseCleaner.strategy = :truncation

		# then, whenever you need to clean the DB
		DatabaseCleaner.clean
		
		# subject = FactoryGirl.create(:subject)
		# teacher = FactoryGirl.create(:teacher, :subjects => [subject])

		# login_as(teacher, scope: :teacher)
	end

	it "should fail all validations" do
		subject = FactoryGirl.create(:subject)
		teacher = FactoryGirl.create(:teacher, :subjects => [subject])

		login_as(teacher, scope: :teacher)

		visit 'teachers/1/your-business'
		click_link_or_button 'home_price_submit_button'
		
		expect(page).to have_content %Q(Couldn't update prices ["Price can't be blank", "Price is not a number", "Duration must be greater than 0"])
	end

	it "should fail if teacher_id is incorrect" do
		subject = FactoryGirl.create(:subject)
		teacher = FactoryGirl.create(:teacher, :subjects => [subject])

		login_as(teacher, scope: :teacher)

		visit 'teachers/1/your-business'
		fill_in 'home_price_price', with: '50'
		fill_in 'home_price_duration', with: '30'
		
		select 'Drums', from: 'home_price_subject_id'
		find('#home_price_teacher_id', visible: false).set(2)
		find('#home_price_no_map', visible: false).set(true)
		click_link_or_button 'home_price_submit_button'
		expect(page).to have_content('You are not the correct teacher')
	end

	it "should fail when subject_id is blank" do
		teacher = FactoryGirl.create(:teacher)

		login_as(teacher, scope: :teacher)

		visit 'teachers/1/your-business'

		fill_in 'home_price_price', with: '50'
		fill_in 'home_price_duration', with: '30'
		find('#home_price_no_map', visible: false).set(true)
		click_link_or_button 'home_price_submit_button'
		expect(page).to have_content %Q(Couldn't update prices ["Subject can't be blank"])

	end

end