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
	validates :start, :end, date: true
	validates :end_time, date: { after: :start }
	validates :title, :school, :start, :end, :teacher_id, presence: true

	before_validation :addTime

	def addTime
		if self.present == '1'
			self.end = Time.now()
		end
	end
end
