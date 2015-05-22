# == Schema Information
#
# Table name: grinds
#
#  id         :integer          not null, primary key
#  subject_id :integer
#  teacher_id :integer
#  capacity   :integer
#  price      :decimal(, )
#  time       :datetime
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Grind < ActiveRecord::Base

  belongs_to :teacher, touch: true
  belongs_to :subject

  validates :subject_id, :teacher_id, :capacity, :price, presence: true

end
