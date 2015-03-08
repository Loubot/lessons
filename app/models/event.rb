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
  validates :teacher_id, presence: true
  validates :start_time, :end_time,  presence: :true
  validates :start_time, :end_time, :overlap => {:exclude_edges => ["start_time", "end_time"]}
  validates :start_time, date: { before: :end_time, message: 'must be after end time' }
  has_one :review
  belongs_to :teacher, touch: true
  #belongs_to :teacher, foreign_key: :student_id

  before_save :add_name

  scope :student_events, ->(student_id) { where(student_id: student_id).order("end_time DESC")}

def student_name
  Teacher.find(self.student_id).full_name
end

def teacher_name
  Teacher.find(self.teacher_id).full_name
end

def self.studentDoMultipleBookings(params)
    date = params[:date]
    startTime = Time.zone.parse("#{date} #{params[:event]['start_time(5i)']}")
    endTime = Time.zone.parse("#{date} #{params[:event]['end_time(5i)']}")
    # e = Event.new(start_time: startTime, end_time: endTime, teacher_id: params[:event][:teacher_id])
    
    # p "errorsssssssss #{e.errors.full_messages}" if !e.valid?
   
    weeks = params[:booking_length].to_i - 1
    
    for i in 0..weeks
      
      newStart = startTime + ((i*7).days) #add a week
      newEnd = endTime + ((i*7).days) #add a week
      p "startTime #{newStart}"
      p "newStart #{newEnd}"
      event = Event.new(start_time: newStart, end_time: newEnd, status: 'active',
                   teacher_id: params[:event][:teacher_id], student_id: params[:event][:student_id])
      # e.save
      return event if !event.valid?
      
    end
    return event  
  end

private

	def add_name #add teachers name as the title
    puts "************ #{self.teacher_id}"
		user = Teacher.find(self.teacher_id)
		self.title = "#{user.first_name} #{user.last_name}"		
	end
end
