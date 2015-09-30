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
#  start_date    :datetime
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  location_id   :integer
#  location_name :string
#  weeks         :integer          default(1)
#  level         :string
#  duration      :integer          default(0)
#

class Grind < ActiveRecord::Base

  belongs_to :teacher, touch: true
  belongs_to :subject

  validates :subject_id, :teacher_id, :location_id, :capacity, :price, :start_date,\
            :level, :subject_name, presence: true
  validates :price, :capacity, numericality: true
  validates :price, numericality: { greater_than_or_equal_to: 0 }
  validates :number_booked, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: :capacity }
  # validates :start_date, date: { after: Time.now }
  validates :start_date, date: { after: Time.now, message: 'must be after end time' }

  # validates :duration, numericality: { greater_than: 0 }
  validates :price, numericality: { greater_than: 0 }
  
  serialize :student_ids

  scope :available, -> { where('(capacity - number_booked) > 0') }


  def number_left
    capacity - number_booked
  end

end
