require 'rails_helper'
require 'database_cleaner'

describe "visit static views" do
	it 'displays how-it-works' do
		visit 'how-it-works'
		expect(page).to have_content 'How Learn Your Lesson Works'
		page.has_title? 'How it works'
	end

	it 'displays mailing_list' do
		visit 'mailing-list'
		expect(page).to have_css('#email')
		page.has_title? 'Mailing list'
	end

	it 'displays welcome' do
		visit :welcome
		expect(page).to have_css('#search_submit')
		page.has_title? 'The place to connect with local teachers and learn'
	end

	it 'displays learn' do
		visit :learn
		expect(page).to have_css('#reg_email')
		page.has_title? 'Login, Sign up to connect with teachers, expand your knowledge'
	end

	it 'displays teach' do
		visit :teach
		expect(page).to have_css('#reg_email')
		page.has_title? 'Connect with local students and teach what you love'
	end
end


describe "the register process" do
	
  before(:each) do
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.clean
  end
  
  it "registers teachers" do
  	visit '/teach'
  	
		fill_in :reg_email, with: 'l@b.com'
		fill_in :reg_password, with: 'password'
		fill_in :reg_password_confirmation, with: 'password'
		fill_in :reg_first_name, with: 'Louis'
		fill_in :reg_last_name, with: 'Angelini'
  	
  	click_button 'sign_up'
  	expect(page).to have_content 'Welcome'
  end

  
  it "registers students" do
  	visit :learn

  	fill_in :reg_email, with: 'l@b.com'
		fill_in :reg_password, with: 'password'
		fill_in :reg_password_confirmation, with: 'password'
		fill_in :reg_first_name, with: 'Louis'
		fill_in :reg_last_name, with: 'Angelini'
  	
  	click_button 'sign_up'
  	expect(page).to have_content 'Welcome'

  end 
end