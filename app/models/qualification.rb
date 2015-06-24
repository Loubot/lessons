# == Schema Information
#
# Table name: qualifications
#
#  id         :integer          not null, primary key
#  title      :string
#  school     :string
#  start      :datetime
#  end        :datetime
#  teacher_id :integer
#  created_at :datetime
#  updated_at :datetime
#  present    :binary
#

class Qualification < ActiveRecord::Base
	belongs_to :teacher, touch: true
	validates :start, :end, :overlap => {:scope => 'teacher_id' }
	validates :start, :end, :teacher_id, presence: true

	before_validation :addTime

	def addTime
		if self.present == '1'
			self.end = Time.now()
		end
	end
end
