require 'rails_helper'

describe 'try to visit pages when not logged in' do
	it 'edit should redirect' do
		visit 'teachers/1/edit'
		expect(page).to have_content('You need to sign in or sign up before continuing.')
		expect(current_path).to eq(root_path)
	end

	it 'qualifications should redirect' do
		visit 'teachers/9/qualification-form'
		expect(page).to have_content('You need to sign in or sign up before continuing.')
		expect(current_path).to eq(root_path)
	end

	it 'your-business should redirect' do
		visit '/teachers/9/your-business'
		expect(page).to have_content('You need to sign in or sign up before continuing.')
		expect(current_path).to eq(root_path)
	end

	it 'teachers-area should redirect' do
		visit '/teachers/9/your-business'
		expect(page).to have_content('You need to sign in or sign up before continuing.')
		expect(current_path).to eq(root_path)
	end
end

describe 'visit pages while logged in' do

	it 'edit should give display title Edit profile' do
		teacher = FactoryGirl.create(:teacher)
		login_as(teacher, :scope => :teacher)
		visit 'teachers/1/edit'
		expect(page).to have_title('Edit profile')
	end

	it "qualification-form should display title qualifications" do
		teacher = FactoryGirl.create(:teacher)
		login_as(teacher, :scope => :teacher)
		visit 'teachers/1/qualification-form'
		expect(page).to have_title('Qualifications')
	end


end