# == Schema Information
#
# Table name: openings
#
#  id         :integer          not null, primary key
#  mon_open   :datetime
#  mon_close  :datetime
#  tues_open  :datetime
#  tues_close :datetime
#  wed_open   :datetime
#  wed_close  :datetime
#  thur_open  :datetime
#  thur_close :datetime
#  fri_open   :datetime
#  fri_close  :datetime
#  sat_open   :datetime
#  sat_close  :datetime
#  sun_open   :datetime
#  sun_close  :datetime
#  teacher_id :integer
#  created_at :datetime
#  updated_at :datetime
#

class Opening < ActiveRecord::Base
	belongs_to :teacher
end
