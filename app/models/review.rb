# == Schema Information
#
# Table name: reviews
#
#  id         :integer          not null, primary key
#  rating     :integer
#  user_id    :integer
#  teacher_id :integer
#  created_at :datetime
#  updated_at :datetime
#  comment    :text
#

class Review < ActiveRecord::Base
  belongs_to :event

  validates :rating, inclusion: 1..5
  validates :teacher_id, :rating, :user_id, presence: true
end
