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
#

require 'test_helper'

class EventTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
