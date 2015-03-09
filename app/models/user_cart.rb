# == Schema Information
#
# Table name: user_carts
#
#  id            :integer          not null, primary key
#  teacher_id    :integer
#  student_id    :integer
#  params        :text
#  tracking_id   :text
#  student_name  :string(255)      default("")
#  student_email :string(255)
#  teacher_email :string(255)
#  created_at    :datetime
#  updated_at    :datetime
#  subject_id    :integer
#

class UserCart < ActiveRecord::Base
  belongs_to :teacher, touch: true
  serialize :params

  validates :teacher_id, :student_id, :params, :tracking_id, presence: true
  validates :tracking_id, uniqueness: true

  # before_update :save_tracking_id
  # before_save :save_tracking_id
  before_validation :save_tracking_id

  def save_tracking_id
    puts "blvvalvavl"
    self.tracking_id = Digest::SHA1.hexdigest([Time.now, rand].join)
  end

  def self.create_single_cart(params, teacher_email, current_teacher)
    u = where(student_id: params[:event][:student_id]).first_or_create
    u.update_attributes(teacher_id: params[:event][:teacher_id],
                         params: event,
                         teacher_email: teacher_email,
                         student_email: current_teacher.email,
                         student_name: "#{current_teacher.full_name}",
                         subject_id: params[:event][:subject_id]
                         )
    u
  end

  def self.create_multiple_cart(params, teacher_email, current_teacher)
    # puts "cart event #{event.inspect}"
    u = where(student_id: params[:event][:student_id]).first_or_create        
    u.update_attributes(teacher_id: params[:event][:teacher_id],
                         teacher_email: teacher_email,
                         params: Event.get_event_params(params),
                         student_email: current_teacher.email,
                         student_name: "#{current_teacher.full_name}",
                         subject_id: params[:event][:subject_id],
                         multiple: true,
                         weeks: params[:booking_length]
                         )
    u
  end

end
