require 'rails_helper'
require 'database_cleaner'
require 'spec_helper'

describe "visit show_teacher page" do
  before do
    @teacher = complete_teacher
    p "@teacher #{@teacher.set_active}"
    
    visit "http://localhost:3000/show-teacher?id=#{@teacher.id}"
    
  end

  it "should display ok" do
    expect(page).to have_content @teacher.first_name
  end

  it "should display teachers info" do
    expect(page).to have_content '@teacher.subjects.first.name'
    expect(page).to have_content @teacher.overview
    expect(page).to have_content @teacher.address
    expect(page).to have_content @teacher.experiences.first.title
    expect(page).to have_content @teacher.qualifications.first.title
    expect(page).to have_css "#location0"
    expect(page).to have_css "img[src*='fake_text']"
  end

 

end
