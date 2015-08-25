require 'rails_helper'
require 'database_cleaner'
require 'spec_helper'

describe "visit show_teacher page" do
  before do
    @teacher = complete_teacher
    p "@teacher #{ @teacher.set_active }"
    p @pic = "#{ @teacher.photos.find { |p| p.id == @teacher.profile }.avatar.url }"
    
    visit "http://localhost:3000/show-teacher?id=#{@teacher.id}"
    
  end

  it "should display ok" do
    expect(page).to have_content @teacher.first_name
  end

  it "should display teachers info" do
    expect(page).to have_content @teacher.subjects.first.name
    expect(page).to have_content @teacher.overview
    expect(page).to have_content @teacher.address
    expect(page).to have_content @teacher.experiences.first.title
    expect(page).to have_content @teacher.qualifications.first.title
    expect(page).to have_css "#location0"
    expect(page).to have_selector "div.profile_pic_container"
    expect(page.find("div.profile_pic_container")['style']).to eq "background-image: url(#{ @pic })"
  end

 

end
