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

  validates :subject_id, :teacher_id, :location_id, :capacity, :price, :start_time, :subject_name, presence: true
  validates :price, :capacity, numericality: true
  validates :price, numericality: { greater_than_or_equal_to: 0 }
  validates :number_booked, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: :capacity }
  # validates :start_time, date: { after: Time.now }
  validates :start_time, date: { after: Time.now, message: 'must be after end time' }
  
  serialize :student_ids

end
