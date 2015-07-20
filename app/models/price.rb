# == Schema Information
#
# Table name: prices
#
#  id          :integer          not null, primary key
#  subject_id  :integer
#  teacher_id  :integer
#  created_at  :datetime
#  updated_at  :datetime
#  location_id :integer
#  price       :decimal(8, 2)
#  duration    :integer          default(0)
#

class Price < ActiveRecord::Base
  # belongs_to :teacher
  belongs_to :location, touch: true
  belongs_to :subject, touch: true
  belongs_to :teacher, touch: true

  validates :subject_id, :teacher_id, :duration, :price, presence: true
  validates :duration, numericality: { greater_than: 0 }
  validates :price, numericality: { greater_than: 0 }
  validate :duration_is_fifteen

  scope :is_valid?, -> { where("home_price IS NOT NULL") }

  after_destroy :update_teacher
  after_update :update_teacher
  after_create :update_teacher  

  def duration_is_fifteen
    errors.add(:duration, 'must be multiple of 15 mins') if (duration % 15 != 0)
  end

  def update_teacher
    Teacher.find(self.teacher_id).set_active
  end

  def self.remove_prices_after_subject_delete(subject, teacher)
    self.where(subject_id: subject, teacher_id: teacher).each do |p|
      p.destroy
    end
  end

 

end
