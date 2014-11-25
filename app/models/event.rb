# == Schema Information
#
# Table name: events
#
#  id         :integer          not null, primary key
#  title      :string(255)
#  start_time :datetime
#  end_time   :datetime
#  status     :string(255)
#  created_at :datetime
#  updated_at :datetime
#  teacher_id :integer
#  time_off   :binary
#  student_id :integer
#  review_id  :integer
#  subject_id :integer
#

class Event < ActiveRecord::Base
  validates :student_id, :teacher_id, presence: true
  validates :start_time, :end_time,  presence: :true
  validates :start_time, :end_time, :overlap => {:exclude_edges => ["start_time", "end_time"]}
  validates :start_time, date: { before: :end_time, message: 'must be after end time' }
  has_one :review
  belongs_to :teacher
  #belongs_to :teacher, foreign_key: :student_id

  before_save :add_name

  scope :student_events, ->(student_id) { where(student_id: student_id).order("end_time DESC")}

def student_name
  Teacher.find(self.student_id).full_name
end

def teacher_name
  Teacher.find(self.teacher_id).full_name
end

private

	def add_name
    puts "************ #{self.teacher_id}"
		user = Teacher.find(self.teacher_id)
		self.title = "#{user.first_name} #{user.last_name}"		
	end
end
