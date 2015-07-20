require 'rails_helper'
require 'database_cleaner'

describe "adding authentications from authentications modal" do
	before (:each) do 
		DatabaseCleaner.strategy = :truncation

		# then, whenever you need to clean the DB
		DatabaseCleaner.clean
		teacher = FactoryGirl.create(:teacher)

		login_as(teacher, scope: :teacher)
		visit 'teachers/1/edit'
		expect(page).to have_content 'Your info'
	end

	it "should add facebook authentication" do 
		
		
		click_link_or_button 'add_facebook_authentication'
		expect(page).to have_content 'Facebook added to login methods.'
	end

	it "should add google to authentications" do
		click_link_or_button 'add_google_authentication'
		expect(page).to have_content 'Google added to login methods.'
	end

	it "should add twitter to authentications" do
		click_link_or_button 'add_twitter_authentication'
		expect(page).to have_content "Twitter added to login methods."
	end
end