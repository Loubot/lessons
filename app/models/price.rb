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
#

class Price < ActiveRecord::Base
  # belongs_to :teacher
  belongs_to :location
  belongs_to :subject

  validates :subject_id, :teacher_id, :price, :location_id, presence: true

  scope :is_valid?, -> { where("home_price IS NOT NULL") }

  after_destroy :update_teacher
  after_update :update_teacher
  after_create :update_teacher

  def update_teacher
    Teacher.find(self.teacher_id).set_active
  end

end
