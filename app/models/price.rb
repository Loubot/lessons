# == Schema Information
#
# Table name: prices
#
#  id           :integer          not null, primary key
#  subject_id   :integer
#  teacher_id   :integer
#  home_price   :decimal(, )
#  travel_price :decimal(, )
#  created_at   :datetime
#  updated_at   :datetime
#

class Price < ActiveRecord::Base
  belongs_to :teacher
  belongs_to :subject
end
