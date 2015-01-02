# == Schema Information
#
# Table name: subjects
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  category_id :integer
#  created_at  :datetime
#  updated_at  :datetime
#

class Subject < ActiveRecord::Base
	belongs_to :category
  has_many :prices
  validates :name, :category_id, presence: true, uniqueness: true

	has_and_belongs_to_many :teachers
end
