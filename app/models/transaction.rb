# == Schema Information
#
# Table name: transactions
#
#  id            :integer          not null, primary key
#  sender        :string(255)
#  trans_id      :string(255)
#  payStripe     :string(255)
#  user_id       :integer
#  teacher_id    :integer
#  pay_date      :datetime
#  tracking_id   :string(255)
#  whole_message :text
#  created_at    :datetime
#  updated_at    :datetime
#

class Transaction < ActiveRecord::Base
  validates :tracking_id, :trans_id,  uniqueness: true
  validates :sender, :user_id, :teacher_id, :pay_date, :whole_message, :trans_id, :tracking_id, :payStripe, :whole_message,  presence: true
end
