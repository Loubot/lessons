# == Schema Information
#
# Table name: prices
#
#  id           :integer          not null, primary key
#  subject_id   :integer
#  teacher_id   :integer
#  home_price   :decimal(8, 2)
#  travel_price :decimal(8, 2)
#  created_at   :datetime
#  updated_at   :datetime
#

class Price < ActiveRecord::Base
  belongs_to :teacher

  scope :is_valid?, -> { where("home_price IS NOT NULL") }

  after_destroy :update_teacher
  after_update :update_teacher
  after_create :update_teacher

  def update_teacher
    Teacher.find(self.teacher_id).set_active
  end

end