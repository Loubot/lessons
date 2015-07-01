# == Schema Information
#
# Table name: grinds
#
#  id            :integer          not null, primary key
#  subject_id    :integer
#  teacher_id    :integer
#  subject_name  :string
#  capacity      :integer
#  number_booked :integer          default(0)
#  price         :decimal(8, 2)    default(0.0), not null
#  start_time    :datetime
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  location_id   :integer
#

class Grind < ActiveRecord::Base

  belongs_to :teacher, touch: true
  belongs_to :subject

  validates :subject_id, :teacher_id, :capacity, :price, :subject_name, presence: true
  serialize :student_ids
end
