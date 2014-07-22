# == Schema Information
#
# Table name: qualifications
#
#  id         :integer          not null, primary key
#  title      :string(255)
#  school     :string(255)
#  start      :datetime
#  end        :datetime
#  teacher_id :integer
#  created_at :datetime
#  updated_at :datetime
#  present    :binary
#

class Qualification < ActiveRecord::Base
	belongs_to :teacher
	validates :start, :end, :overlap => true
	validates :start, :end, :teacher_id, presence: true

	before_validation :addTime

	def addTime
		if self.present == '1'
			self.end = Time.now()
		end
	end
end
