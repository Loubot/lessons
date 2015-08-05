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

describe "teachers controls" do
  before(:each) do
    DatabaseCleaner.strategy = :truncation

    # then, whenever you need to clean the DB
    DatabaseCleaner.clean
    @category =  FactoryGirl.create(:category)
    
    price = FactoryGirl.create(:price)
    # @subject = FactoryGirl.create(:subject)
    subject = FactoryGirl.create(:subject)
    experience = FactoryGirl.create(:experience)
    location = FactoryGirl.create(:location)

    @teacher = FactoryGirl.create(:teacher, :admin, :complete, prices: [price])
    @teacher.subjects << subject
    @teacher.experiences << experience
    @teacher.locations << location
    p "@teacher #{@teacher.set_active}"
    @teacher2 = FactoryGirl.create(:teacher)
    
    login_as(@teacher, scope: :teacher)
    visit 'http://localhost:3000/admin-panel'
    expect(page).to have_content "Music:"
    click_link_or_button "Music: id = 1"
    expect(page).to have_content "Bass: id = 1"
  end

  it "should show a teachers profile" do
    click_link_or_button "teachers_list"
    expect(page).to have_content "Louis (email"
    expect(page).to have_css '.list-group-item-success'
  end

  # it "should display teachers profile" do
  #   click_link_or_button "teachers_list"
  #   p ".view_profile_#{@teacher.id}"
  #   find(".view_profile_#{@teacher.id}").click
  #   expect(page).to have_content "@teacher.email"
  # end
end