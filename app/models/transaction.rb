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
#  amount        :decimal(8, 2)    default(0.0), not null
#

class Transaction < ActiveRecord::Base
  belongs_to :teacher, touch: true
  serialize :whole_message
  validates :tracking_id, :trans_id,  uniqueness: true
  validates :sender, :user_id, :teacher_id, :pay_date, :amount, :whole_message, :trans_id, :tracking_id, :payStripe, :whole_message,  presence: true

  before_validation :save_tracking_id

  def save_tracking_id
    
    self.tracking_id = Digest::SHA1.hexdigest([Time.now, rand, self.id].join)
  end
end
