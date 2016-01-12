# == Schema Information
#
# Table name: teachers
#
#  id                     :integer          not null, primary key
#  first_name             :string
#  last_name              :string
#  overview               :text             default("")
#  created_at             :datetime
#  updated_at             :datetime
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string
#  last_sign_in_ip        :string
#  admin                  :boolean
#  profile                :integer
#  is_teacher             :boolean          default(FALSE), not null
#  paypal_email           :string           default("")
#  stripe_access_token    :string           default("")
#  is_active              :boolean          default(FALSE), not null
#  will_travel            :boolean          default(FALSE), not null
#  stripe_user_id         :string
#  address                :string           default("")
#  paid_up                :boolean          default(FALSE)
#  paid_up_date           :date
#  profile_views          :integer          default(0)
#

require 'rails_helper'

RSpec.describe Teacher, type: :model do
  it "creates a teacher with validations" do
  	t = FactoryGirl.build(:teacher)
  	expect(t).to be_valid
  end

  before(:each) do
  	
  end

  it "updates paypal_email" do
  	t = FactoryGirl.create(:teacher)
  	expect(t).to be_valid
  	t.paypal_verify({ teacher:{ paypal_email: 'lllouis@yahoo.com', paypal_first_name: 'Louis', paypal_last_name: 'Angelini' } })
  	expect(t.paypal_email).to eq('lllouis@yahoo.com')
  end
  	
end
