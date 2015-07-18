require 'rails_helper'
require 'database_cleaner'


describe 'posts to qualifications' do
	it "shouldn't be valid" do
		t = FactoryGirl.create(:teacher)
		login_as(t, scope: :teacher)
		visit '/teachers/1/qualification-form'

		fill_in 'qualification_name', with: ''
		fill_in 'qualification_school', with: ''
		
		click_link_or_button('qualification_submit')
		expect(page).to have_content('Failed to save qualification')
	end

	it "should fail title validation" do
		t = FactoryGirl.create(:teacher)
		login_as(t, scope: :teacher)
		visit '/teachers/1/qualification-form'

		fill_in 'qualification_name', with: ''
		fill_in 'qualification_school', with: 'UCC'
		
		click_link_or_button('qualification_submit')
		expect(page).to have_content("Title can't be blank")
	end

	it "should fail school validation" do
		t = FactoryGirl.create(:teacher)
		login_as(t, scope: :teacher)
		visit '/teachers/1/qualification-form'

		fill_in 'qualification_name', with: 'Degree in Music'
		fill_in 'qualification_school', with: ''
		
		click_link_or_button('qualification_submit')
		expect(page).to have_content("School can't be blank")
	end

	it "should fail date overlap validation" do
		t = FactoryGirl.create(:teacher)
		login_as(t, scope: :teacher)
		visit '/teachers/1/qualification-form'

		fill_in 'qualification_name', with: 'Degree in Music'
		fill_in 'qualification_school', with: 'UCC'
		select "2015", from: "qualification[start(1i)]"
		select "July", from: "qualification[start(2i)]"
		select "2007", from: "qualification[end(1i)]"
		select "July", from: "qualification[end(2i)]"
		
		click_link_or_button('qualification_submit')
		expect(page).to have_content('Failed to save qualification ["End translation missing')
	end

	it 'should create a qualification using 2 dates' do
		t = FactoryGirl.create(:teacher)
		login_as(t, scope: :teacher)
		visit '/teachers/1/qualification-form'

		fill_in 'qualification_name', with: 'Degree in Music'
		fill_in 'qualification_school', with: 'UCC'
		select "2007", from: "qualification[start(1i)]"
		select "July", from: "qualification[start(2i)]"
		select "2015", from: "qualification[end(1i)]"
		select "July", from: "qualification[end(2i)]"

		click_link_or_button('qualification_submit')
		expect(page).to have_content('Qualification saved')
	end

	end



end