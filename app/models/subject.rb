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
	validates :name, :category_id, presence: true
end
