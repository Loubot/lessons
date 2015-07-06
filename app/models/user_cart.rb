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
#  duration      :integer          default(0)
#  start_time    :datetime
#  price_id      :integer
#  date          :date
#

class UserCart < ActiveRecord::Base
  belongs_to :teacher, touch: true
  serialize :params

  # validates :teacher_id, :teacher_email, :student_id, :params, :tracking_id, :amount, presence: true
  validates :tracking_id, uniqueness: true
  # validates :amount, :numericality => { :greater_than => 0 }

  # before_update :save_tracking_id
  # before_create :save_tracking_id
  before_validation :save_tracking_id

  def save_tracking_id
    
    self.tracking_id = Digest::SHA1.hexdigest([Time.now, rand, self.id].join)
  end

  def self.initial(params)
    if !params.has_key? :location_id
      cart = self.create!(
          booking_type: 'home'
        )
    else
      self.create!(
          booking_type: 'single'
        )
    end

  end

  def self.membership_cart(teacher, email)
    cart = self.create!(
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
    cart = self.new

    cart.update_attributes(
                    teacher_id: params[:event][:teacher_id],
                    student_id: params[:event][:student_id],
                    params: Event.get_event_params(params, price),
                    student_name: params[:event][:student_name],
                    teacher_name: params[:event][:teacher_name],
                    student_email: params[:event][:student_email],
                    teacher_email: params[:event][:teacher_email],
                    address: params[:home_address],
                    booking_type: 'home',
                    multiple: false,
                    package_id: 0,
                    amount: price.price.to_f,
                    duration: price.duration
                  )
    cart.save!

    cart
  end

  def self.create_single_cart(params, teacher_email, current_teacher, location_id, amount)
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
                            weeks: 1,
                            location_id: location_id,
                            amount: amount,
                            package_id: 0
                          )
    cart.save!
    cart
  end

  def self.create_multiple_cart(params, teacher_email, current_teacher, location_id, amount)
    puts "cart event multiple #{params[:booking_length]}"
    cart = self.new      
    cart.update_attributes(
                            teacher_id: params[:event][:teacher_id],
                            teacher_email: teacher_email,
                            params: Event.get_event_params(params),
                            student_email: current_teacher.email,
                            student_name: current_teacher.full_name,
                            student_id: current_teacher.id,
                            subject_id: params[:event][:subject_id],
                            multiple: true,
                            weeks: params[:booking_length],
                            booking_type: 'multiple',
                            location_id: location_id,
                            amount: amount,
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
