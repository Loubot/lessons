# == Schema Information
#
# Table name: experiences
#
#  id          :integer          not null, primary key
#  title       :string(255)
#  description :text
#  teacher_id  :integer
#  start       :datetime
#  end         :datetime
#  created_at  :datetime
#  updated_at  :datetime
#

class Experience < ActiveRecord::Base
	belongs_to :teacher
end
