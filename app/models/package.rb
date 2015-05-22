# == Schema Information
#
# Table name: packages
#
#  id            :integer          not null, primary key
#  subject_name  :string           default("")
#  teacher_id    :integer
#  subject_id    :integer
#  price         :decimal(, )      default(0.0)
#  no_of_lessons :integer          default(0)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class Package < ActiveRecord::Base
  belongs_to :teacher
  belongs_to :subject

  validates :price, :teacher_id, :subject_id, :subject_name, presence: true

  validates :price, :format => { :with => /\A\d+(?:\.\d{0,2})?\z/ },
                       :numericality => {:greater_than => 0}

  validates :no_of_lessons, :numericality => { greater_than: 0, less_than: 53 }

end
