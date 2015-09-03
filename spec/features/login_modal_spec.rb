require 'rails_helper'
require 'database_cleaner'

describe "login user through login modal" do

	it "should fail with incorrect user name"	do
		t = FactoryGirl.create(:teacher)

		visit 'welcome'
		
		page.fill_in 'login_modal_email', with: 'balls'
		page.fill_in 'login_modal_password', with: t.password
		click_link_or_button('sign_in_submit')
		

		expect(page).to have_content('Invalid email or password')
		expect(current_path).to eq('/')

	end

	it "should fail with incorrect password"	do
		t = FactoryGirl.create(:teacher)

		visit 'welcome'
		
		page.fill_in 'login_modal_email', with: t.email
		page.fill_in 'login_modal_password', with: 'ballsack'
		click_link_or_button('sign_in_submit')
		

		expect(page).to have_content('Invalid email or password')
		expect(current_path).to eq('/')

	end

	it 'should login through the login modal' do
		t = FactoryGirl.create(:teacher)

		visit 'welcome'
		
		page.fill_in 'login_modal_email', with: t.email
		page.fill_in 'login_modal_password', with: t.password
		click_link_or_button('sign_in_submit')
		

		expect(page).to have_content('Signed in successfully')
		expect(current_path).to eq('/welcome')
		
	end
end