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
#

class Review < ActiveRecord::Base
  has_and_belongs_to_many :teachers
  has_and_belongs_to_many :users

  validates :teacher_id, :rating, :user_id, presence: true
end
