# == Schema Information
#
# Table name: friendships
#
#  id         :integer          not null, primary key
#  teacher_id :integer
#  student_id :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Friendship < ActiveRecord::Base
  belongs_to :teacher
  belongs_to :student, class_name: 'Teacher'

  validates :teacher_id, :student_id, presence: true

  validates_uniqueness_of :teacher_id, scope: :student_id, message: 'association already exists'
end
