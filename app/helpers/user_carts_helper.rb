# == Schema Information
#
# Table name: user_carts
#
#  id            :integer          not null, primary key
#  teacher_id    :integer
#  student_id    :integer
#  params        :text
#  tracking_id   :text
#  student_name  :string           default("")
#  student_email :string
#  teacher_email :string
#  created_at    :datetime
#  updated_at    :datetime
#  subject_id    :integer
#  multiple      :boolean          default(FALSE)
#  weeks         :integer          default(0)
#  address       :string           default("")
#  booking_type  :string           default("")
#  package_id    :integer          default(0)
#  amount        :decimal(8, 2)    default(0.0), not null
#  teacher_name  :string           default("")
#  location_id   :integer
#  status        :string           default("")
#  start_time    :datetime
#  price_id      :integer
#  date          :date
#

module UserCartsHelper

  
end
