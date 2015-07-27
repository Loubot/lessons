require 'rails_helper'
require 'database_cleaner'


describe "admin-panel errors" do
  it "shouldn't display if teacher isn't logged in" do
    visit 'http://localhost:3000/admin-panel'
    expect(page).to have_content 'Close You need to sign in or sign up before continuing'
  end

  it "shouldn't display if teacher isn't an admin" do
    DatabaseCleaner.strategy = :truncation

    # then, whenever you need to clean the DB
    DatabaseCleaner.clean
    teacher = FactoryGirl.create(:teacher)
    login_as(teacher, scope: :teacher)
    visit 'http://localhost:3000/admin-panel'
    expect(page).to have_content 'Tut tut. You are not an admin'
  end
end

describe "display admin-panel" do

  before(:each) do
    DatabaseCleaner.strategy = :truncation

    # then, whenever you need to clean the DB
    DatabaseCleaner.clean
    teacher = FactoryGirl.create(:teacher, :admin)
    login_as(teacher, scope: :teacher)
    visit 'http://localhost:3000/admin-panel'
  end

  it "should show when teacher is an admin" do
    
    expect(page).to have_content 'List of categories'
  end 

end

describe "creating subjects and categories" do
  before(:each) do
    DatabaseCleaner.strategy = :truncation

    # then, whenever you need to clean the DB
    DatabaseCleaner.clean
    teacher = FactoryGirl.create(:teacher, :admin)
    login_as(teacher, scope: :teacher)
    visit 'http://localhost:3000/admin-panel'
  end

  it "should create a category" do
    
    page.fill_in 'category_name', with: 'Music'
    click_link_or_button 'category_submit'
    expect(page).to have_content 'Category created successfully'
    expect(page).to have_content "Music: id = 1"
  end

  it "should create a subject" do 
    category = FactoryGirl.create(:category)
    click_link_or_button 'category_submit'
    # click_link_or_button "#{category.name.downcase}"
    page.fill_in 'subject_name', with: 'Drums'
    click_link_or_button 'subject_submit'
    expect(page).to have_content 'Subject created successfully'
  end
end


describe "deleting subjects and categories" do
  before(:each) do
    DatabaseCleaner.strategy = :truncation

    # then, whenever you need to clean the DB
    DatabaseCleaner.clean
    teacher = FactoryGirl.create(:teacher, :admin)
    @category =  FactoryGirl.create(:category)
    @subject = FactoryGirl.create(:subject)
    login_as(teacher, scope: :teacher)
    visit 'http://localhost:3000/admin-panel'
    expect(page).to have_content "Music:"
    click_link_or_button "Music: id = 1"
    expect(page).to have_content "Bass: id = 1"
  end

  it "should delete a subject" do    
    
    click_link_or_button "delete_bass"
    expect(page).to have_content "Subject deleted successfully"
  end

  it "should delete a category" do
    click_link_or_button "Delete music"
    expect(page).to have_content "Category deleted successfully"
  end
end