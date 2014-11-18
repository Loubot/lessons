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
  belongs_to :subject
end
