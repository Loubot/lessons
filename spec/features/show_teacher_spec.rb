require 'rails_helper'
require 'database_cleaner'
require 'spec_helper'

describe "visit show_teacher page" do
  before(:each) do
    DatabaseCleaner.strategy = :truncation

    # # then, whenever you need to clean the DB
    DatabaseCleaner.clean
    @category = FactoryGirl.create(:category)
    
    @price = FactoryGirl.create(:price)
    # @subject = FactoryGirl.create(:subject)
    @subject = FactoryGirl.create(:subject)
    @category.subjects << @subject
    @experience = FactoryGirl.create(:experience)
    @location = FactoryGirl.create(:location)
    @photo = FactoryGirl.create(:photo)    

    @teacher = FactoryGirl.create(:teacher, :admin, :complete)
    @teacher.photos << @photo
    @teacher.prices << @price
    @teacher.subjects << @subject
    @teacher.experiences << @experience
    @teacher.locations << @location
    p "@teacher #{@teacher.set_active}"
    
    visit "http://localhost:3000/show-teacher?id=#{@teacher.id}"
    
  end

  it "should display ok" do
    expect(page).to have_content @teacher.first_name
  end
end