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
#  present     :binary
#  created_at  :datetime
#  updated_at  :datetime
#

require 'test_helper'

class ExperienceTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
