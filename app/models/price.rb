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

  def self.is_valid?
    prices = where("home_price IS NOT NULL OR travel_price IS NOT NULL")
  end
  
end
