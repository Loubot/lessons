class Qualification < ActiveRecord::Base
	belongs_to :teacher
	validates :start, :end, :overlap => true
	validates :start, :end, :teacher_id, presence: true
end
