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
#  message       :text
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class Conversation < ActiveRecord::Base
  validates :teacher_id, :teacher_email, :student_email, :message, presence: true
end
