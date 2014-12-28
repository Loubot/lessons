# == Schema Information
#
# Table name: teachers
#
#  id                     :integer          not null, primary key
#  first_name             :string(255)
#  last_name              :string(255)
#  address                :text
#  overview               :text             default("")
#  created_at             :datetime
#  updated_at             :datetime
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  admin                  :boolean
#  profile                :integer
#  is_teacher             :boolean          default(FALSE), not null
#  paypal_email           :string(255)      default("")
#  stripe_access_token    :string(255)      default("")
#  is_active              :boolean          default(FALSE), not null
#  will_travel            :boolean          default(FALSE), not null
#

class Teacher < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :omniauthable,
         :recoverable, :rememberable, :trackable, :validatable

  #validates :email, confirmation: true, uniqueness: { case_sensitive: false }
  after_validation :reverse_geocode

  has_many :photos, as: :imageable, dependent: :destroy

  has_many :reviews, dependent: :destroy

  has_and_belongs_to_many :subjects

  has_many :experiences
  has_many :events
  #has_many :events, foreign_key: :student_id
  has_many :qualifications
  
  has_many :transactions, foreign_key: :user_id
  has_many :identities, dependent: :destroy
  has_many :prices, dependent: :destroy
  has_one :user_cart
  has_one :opening

  geocoded_by :full_street_address, :latitude  => :lat, :longitude => :lon
  reverse_geocoded_by :lat, :lon

  self.per_page = 5

  #scope
  def self.check_if_valid
    teachers = where(is_active: true)
  end

  def full_street_address
    self.address
  end

  def full_name
    "#{self.first_name} #{self.last_name}"
  end

  def add_identity(auth)
    Identity.create!(uid: auth[:uid], provider: auth[:provider], teacher_id: self.id)
  end

  def set_active
    is_teacher_valid ? self.update_attributes(is_active: true) : self.update_attributes(is_active: false)
  end

  def is_teacher_valid
    self.lat && self.lon && (self.paypal_email != "" || self.stripe_access_token != "" )  && self.profile != nil && self.overview != "" && (self.subjects.size > 0) && check_rates #next method
  end

  def check_rates
    self.subjects.each do |s| 
      return false if !Price.find_by(subject_id: s.id, teacher_id: self.id) 
    end
    true
  end

  def is_teacher_valid_message
    error_message_array = []
    
    error_message_array.push " location not entered" if !self.lat || !self.lon
    error_message_array.push " profile picture not set" if !self.profile
    error_message_array.push " payment option not specified" if (self.paypal_email == "" && self.stripe_access_token == "")
    error_message_array.push " please fill in your overview" if self.overview == ""
    error_message_array.push " you must set all your rates" if !check_rates
    error_message_array.push " you must select a subject" if self.subjects.size < 1
    if error_message_array.empty?
      self.update_attributes(is_active: true) #update is_active attribute
      false
    else
      self.update_attributes(is_active: false) #update is active attribute
      error_message_array.join(',').capitalize.insert(0, "Your profile is not visible: ")#return profile active message
    end
     
  end

  def self.create_new_with_omniauth(auth, source_address)
    teacher = create! do |teacher|
      teacher.email = auth['extra']['raw_info']['email']
      teacher.first_name = auth['extra']['raw_info']['first_name'] 
      teacher.last_name = auth['extra']['raw_info']['last_name']
      source_address == "/teach" ? teacher.is_teacher = true : teacher.is_teacher = false      
    end

    teacher.add_identity(auth)
    teacher
  end

  def add_prices(params)
    price = Price.find_or_initialize_by(teacher_id: params[:teacher_id], subject_id: params[:subject_id])
    if params[:rate_select] == "Home rate:"
      price.update_attributes(home_price: params[:rate]) 

    else
      price.update_attributes(travel_price: params[:rate])
    end
    
  end

  def set_will_travel(params)
    params[:will_travel] == "Home only" ? self.update_attributes!(will_travel: false) : self.update_attributes!(will_travel: true)
    
  end

  def password_required?
    super && self.identities.size > 0
  end

  def paypal_verify(params)
    api = PayPal::SDK::AdaptiveAccounts::API.new(
      :mode      => "sandbox",  # Set "live" for production
      :app_id    => "APP-80W284485P519543T",
      :username  => "lllouis_api1.yahoo.com",
      :password  => "MRXUGXEXHYX7JGHH",
      :signature => "AFcWxV21C7fd0v3bYYYRCpSSRl31Akm0pm37C5ZCuhi7YDnTxAVFtuug",
      :device_ipaddress => "127.0.0.1",
      :sandbox_email_address => "lllouis@yahoo.com" )
    get_verified_status_request = api.build_get_verified_status( :emailAddress => params[:teacher][:paypal_email], :matchCriteria => "NONE" )
    response = api.get_verified_status(get_verified_status_request)
    self.update_attributes(paypal_email: params[:teacher][:paypal_email]) if response.success?
    response
    
  end
end
