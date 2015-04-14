# == Schema Information
#
# Table name: packages
#
#  id            :integer          not null, primary key
#  subject_name  :string           default("")
#  teacher_id    :integer
#  subject_id    :integer
#  price         :decimal(, )      default("0")
#  no_of_lessons :integer          default("0")
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class Package < ActiveRecord::Base
  belongs_to :teacher
  belongs_to :subject

  validates :price, :teacher_id, :subject_id, presence: true
end
