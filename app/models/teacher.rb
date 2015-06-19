# == Schema Information
#
# Table name: teachers
#
#  id                     :integer          not null, primary key
#  first_name             :string(255)
#  last_name              :string(255)
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
#  stripe_user_id         :string
#  address                :string           default("")
#  paid_up                :boolean          default(FALSE)
#  paid_up_date           :date
#

class Teacher < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable

  devise :database_authenticatable, :registerable, :omniauthable,
         :recoverable, :rememberable, :trackable, :validatable

  validates :email,  uniqueness: { case_sensitive: false }
  validates :email, :first_name, :last_name, presence: true
  validates :is_teacher, inclusion: { in: [true, false], message: "%{value} must be set true or false" }
  validates_confirmation_of :password, message: "should match verification"
  # after_validation :reverse_geocode

  after_initialize :set_paid_up_date

  has_many :photos, as: :imageable, dependent: :destroy

  has_many :locations, dependent: :destroy

  has_many :reviews, dependent: :destroy

  has_many :identities, dependent: :destroy

  has_many :packages, dependent: :destroy

  has_many :grinds, dependent: :destroy

  has_and_belongs_to_many :subjects, touch: true

  has_many :experiences, dependent: :destroy
  has_many :events, dependent: :destroy
  #has_many :events, foreign_key: :student_id
  has_many :qualifications, dependent: :destroy
  
  has_many :transactions, foreign_key: :user_id, dependent: :destroy
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

  def add_to_mailing_lists
    gb = Gibbon::API.new(ENV['_mail_chimp_api'], { :timeout => 15 })
    list_id = self.is_teacher ? ENV['MAILCHIMP_TEACHER_LIST'] : ENV['MAILCHIMP_STUDENT_LIST']
    
    begin
      gb.lists.subscribe({
                          :id => list_id,
                           :email => {
                                      :email => self.email                                       
                                      },
                                      :merge_vars => { :FNAME => self.first_name },
                            :double_optin => false
                          })

      logger.info "subscribed to mailchimp"
      # flash[:success] = "Thank you, your sign-up request was successful! Please check your e-mail inbox."
    rescue Gibbon::MailChimpError, StandardError => e
      puts "list subscription failed !!!!!!!!!!"
      logger.info e.to_s
      # flash[:danger] = e.to_s
    end
    
  end

  def set_paid_up_date
    self.paid_up_date = 6.month.ago
  end

  def full_street_address
    self.address
  end

  def mailboxer_email(object)
    return self.email
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
    (self.paypal_email != "" || self.stripe_access_token != "" )  && self.profile != nil && self.overview != "" && (self.subjects.size > 0) && self.experiences.size > 0 && self.locations.size != 0 && check_rates #next method
  end

  def check_rates
    prices = self.prices
    self.locations.each do |l|
      self.subjects.each do |s|
        if !(prices.any? { |p| p.location_id == l.id && p.subject_id == s.id } ||
               prices.any? { |p| p.subject_id == s.id && p.no_map == true })
          return false
        end

      end    
    end

  end

  def is_teacher_valid_message
    error_message_array = []
    
    # error_message_array.push " location not entered" if !self.lat || !self.lon
    error_message_array.push " profile picture not set" if !self.profile
    error_message_array.push " payment option not specified" if (self.paypal_email == "" && self.stripe_access_token == "")
    error_message_array.push " please fill in your overview" if self.overview == ""
    error_message_array.push " you must set at least one price per subject" if !self.check_rates
    error_message_array.push " you must select a subject" if self.subjects.size < 1
    error_message_array.push " you must enter some experience" if self.experiences.size < 1
    error_message_array.push " you must enter at least one location" if self.locations.size < 1
    # error_message_array.push " you must pay your subscription for this month " if self.paid_up == false

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

  def self.from_omniauth(auth) #find or initialize new teacher for omniauth registration
    where(email: auth['info']['email']).first_or_initialize do |t|
      t.email = auth['info']['email']
      t.password = Devise.friendly_token[0,20]
      t.first_name = auth['info']['first_name']
      t.last_name = auth['info']['last_name']
    end
  end

  def paypal_verify(params)
    api = PayPal::SDK::AdaptiveAccounts::API.new(
      :app_id    => ENV['PAYPAL_APP_ID'],
      :username  => ENV['PAYPAL_USER_ID'],
      :password  => ENV['PAYPAL_PASSWORD'],
      :signature => ENV['PAYPAL_SIGNATURE']
       )
    get_verified_status_request = api.build_get_verified_status( 
                      :emailAddress => params[:teacher][:paypal_email], 
                      :matchCriteria => "NAME",
                      :firstName => params[:teacher][:paypal_first_name],
                      :lastName => params[:teacher][:paypal_last_name]
                      )
    response = api.get_verified_status(get_verified_status_request)
    self.update_attributes(paypal_email: params[:teacher][:paypal_email]) if response.success?
    p "Paypal email updated #{response.inspect}" if response.success?
    p "paypal registration failed #{response.inspect}" if !response.success?
    response
    
  end
end
