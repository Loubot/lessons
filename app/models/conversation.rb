# == Schema Information
#
# Table name: conversations
#
#  id            :integer          not null, primary key
#  teacher_id    :integer
#  student_id    :integer
#  teacher_email :string
#  student_email :string
#  teacher_name  :string
#  student_name  :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class Conversation < ActiveRecord::Base
  validates :teacher_id, :teacher_email, :student_email, presence: true

  has_many :messages, dependent: :destroy
end
