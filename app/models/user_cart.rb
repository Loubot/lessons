# == Schema Information
#
# Table name: user_carts
#
#  id          :integer          not null, primary key
#  teacher_id  :integer
#  student_id  :integer
#  params      :text
#  tracking_id :text
#  created_at  :datetime
#  updated_at  :datetime
#

class UserCart < ActiveRecord::Base
  belongs_to :teacher
  serialize :params

  before_update :increment_tracking_id
  before_save :save_tracking_id

  def save_tracking_id
    self.tracking_id = Digest::SHA1.hexdigest([Time.now, rand].join)
  end


  def increment_tracking_id
    self.tracking_id =  Digest::SHA1.hexdigest([Time.now, rand].join)
  end
end
