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
#  address       :string           default("")
#  weeks         :integer          default(0)
#  multiple      :boolean          default(FALSE)
#  string        :string           default("")
#  booking_type  :string           default("")
#  package_id    :integer          default(0)
#  amount        :decimal(8, 2)    default(0.0), not null
#  teacher_name  :string           default("")
#

class UserCart < ActiveRecord::Base
  belongs_to :teacher, touch: true
  serialize :params

  validates :teacher_id, :teacher_email, :student_id, :params, :tracking_id, :amount, presence: true
  validates :tracking_id, uniqueness: true

  # before_update :save_tracking_id
  # before_create :save_tracking_id
  before_validation :save_tracking_id

  def save_tracking_id
    
    self.tracking_id = Digest::SHA1.hexdigest([Time.now, rand, self.id].join)
  end

  def self.membership_cart(teacher, email)
    cart = self.create(
                    teacher_id: teacher,
                    teacher_email: email,
                    student_id: 0,
                    params: 'membership payment',
                    booking_type: 'membership',
                    multiple: 'false',
                    package_id: 0
                  )
    p "membership cart #{cart.inspect}"
    cart
  end

  def self.home_booking_cart(params, price)
    puts "cart params #{params}"
    cart = self.find_or_initialize_by(student_id: params[:student_id])

    cart.update_attributes(
                    teacher_id: params[:teacher_id],
                    student_id: params[:student_id],
                    params: params,
                    student_name: params[:student_name],
                    teacher_name: params[:teacher_name],
                    student_email: params[:student_email],
                    teacher_email: params[:teacher_email],
                    address: params[:home_address],
                    booking_type: 'home',
                    multiple: false,
                    package_id: 0,
                    amount: price.to_f
                  )
    # cart.save!

    cart
  end

  def self.create_single_cart(params, teacher_email, current_teacher)
    cart = self.new
    cart.update_attributes(
                            teacher_id: params[:event][:teacher_id],
                            params: Event.get_event_params(params),
                            teacher_email: teacher_email,
                            student_id: current_teacher.id,
                            student_email: current_teacher.email,
                            student_name: "#{current_teacher.full_name}",
                            subject_id: params[:event][:subject_id],
                            multiple: false,
                            booking_type: 'single',
                            package_id: 0
                          )
    cart.save!
    cart
  end

  def self.create_multiple_cart(params, teacher_email, current_teacher)
    puts "cart event multiple #{params[:booking_length]}"
    cart = where(student_id: params[:event][:student_id]).first_or_create        
    cart.update_attributes(
                            teacher_id: params[:event][:teacher_id],
                            teacher_email: teacher_email,
                            params: Event.get_event_params(params),
                            student_email: current_teacher.email,
                            student_name: "#{current_teacher.full_name}",
                            subject_id: params[:event][:subject_id],
                            multiple: true,
                            weeks: params[:booking_length],
                            booking_type: 'multiple',
                            package_id: 0
                          )
    cart.save!
    cart
  end

  def self.create_package_cart(params, current_teacher, package)
    cart = where(student_id: params[:student_id]).first_or_create
    cart.update_attributes(
                            teacher_id: params[:teacher_id],
                            teacher_email: params[:teacher_email],
                            params: params,
                            student_email: current_teacher.email,
                            student_name: current_teacher.full_name,
                            subject_id: package.subject_id,
                            address: '',
                            multiple: false,
                            booking_type: 'package',
                            package_id: package.id
                          )
    cart
  end

end
