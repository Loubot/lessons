# == Schema Information
#
# Table name: reviews
#
#  id         :integer          not null, primary key
#  rating     :integer
#  user_id    :integer
#  teacher_id :integer
#  created_at :datetime
#  updated_at :datetime
#  comment    :text
#

require 'test_helper'

class ReviewTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
