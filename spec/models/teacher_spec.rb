require 'rails_helper'

RSpec.describe Teacher, type: :model do
  it "create a teacher with validations" do
  	t = FactoryGirl.build(:teacher)
  	expect(t).to be_valid
  end
  	
end
