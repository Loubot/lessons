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

	before (:each) do 
		DatabaseCleaner.strategy = :truncation

		# then, whenever you need to clean the DB
		DatabaseCleaner.clean
		teacher = FactoryGirl.create(:teacher)
		login_as(teacher, scope: :teacher)
	end
	
	context 'go to edit page' do
		it 'should open edit page' do
			visit 'teachers/1/edit'
			expect(page).to have_title('Edit profile')
		end
	end

	context 'go to qualifications page' do

		it "should open the qualifications page" do
			visit 'teachers/1/qualification-form'
			expect(page).to have_title('Qualifications')

		end
	end

	context 'go to your-business page' do
		it 'should open the your-business page' do
			visit 'teachers/1/your-business'
			expect(page).to have_title('Tell us where you are')
		end
	end

	context 'go to teachers-area' do
		it 'should open the teachers-area page' do
			visit 'teachers/1/teachers-area' 
			expect(page).to have_title('Teachers area')
		end
	end


end