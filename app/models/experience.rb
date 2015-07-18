# == Schema Information
#
# Table name: experiences
#
#  id          :integer          not null, primary key
#  title       :string
#  description :text
#  teacher_id  :integer
#  start       :datetime
#  end         :datetime
#  present     :binary
#  created_at  :datetime
#  updated_at  :datetime
#

class Experience < ActiveRecord::Base
	belongs_to :teacher, touch: true

	validates :title, :description, :teacher_id, :start, presence: true

	validates :start, :end, date: true

	validates :end, date: { after: :start }

	before_save :addTime


	def addTime
		if self.present == '1'
			self.end = self.start + 5.years
		end
	end
end
