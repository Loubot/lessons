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
#

class Event < ActiveRecord::Base
validates :start_time, :end_time,  presence: :true
validates :start_time, :end_time, :overlap => true
belongs_to :teacher
end
