# == Schema Information
#
# Table name: openings
#
#  id           :integer          not null, primary key
#  mon_open     :datetime
#  mon_close    :datetime
#  tues_open    :datetime
#  tues_close   :datetime
#  wed_open     :datetime
#  wed_close    :datetime
#  thur_open    :datetime
#  thur_close   :datetime
#  fri_open     :datetime
#  fri_close    :datetime
#  sat_open     :datetime
#  sat_close    :datetime
#  sun_open     :datetime
#  sun_close    :datetime
#  teacher_id   :integer
#  created_at   :datetime
#  updated_at   :datetime
#  all_day_mon  :boolean          default("false")
#  all_day_tues :boolean          default("false")
#  all_day_wed  :boolean          default("false")
#  all_day_thur :boolean          default("false")
#  all_day_fri  :boolean          default("false")
#  all_day_sat  :boolean          default("false")
#  all_day_sun  :boolean          default("false")
#

class Opening < ActiveRecord::Base
	belongs_to :teacher, touch: true
end
