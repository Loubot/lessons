require 'rails_helper'
require 'database_cleaner'

describe "visit show_teacher page" do
  before(:each) do
    DatabaseCleaner.strategy = :truncation

    # then, whenever you need to clean the DB
    DatabaseCleaner.clean
    # @category =  FactoryGirl.create(:category)
    
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
  
  it "should display ok" do

  end
end