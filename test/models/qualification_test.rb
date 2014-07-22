# == Schema Information
#
# Table name: qualifications
#
#  id         :integer          not null, primary key
#  title      :string(255)
#  school     :string(255)
#  start      :datetime
#  end        :datetime
#  teacher_id :integer
#  created_at :datetime
#  updated_at :datetime
#  present    :binary
#

require 'test_helper'

class QualificationTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
