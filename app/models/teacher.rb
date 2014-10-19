# == Schema Information
#
# Table name: teachers
#
#  id                     :integer          not null, primary key
#  first_name             :string(255)
#  last_name              :string(255)
#  address                :text
#  overview               :text
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
#  lat                    :float
#  lon                    :float
#  profile                :integer
#  opening                :datetime
#  closing                :datetime
#  rate                   :decimal(8, 2)
#  is_teacher             :boolean
#  paypal_email           :string(255)      default("")
#  stripe_access_token    :string(255)      default("")
#

class Teacher < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  validates :email, confirmation: true, uniqueness: { case_sensitive: false }

  has_many :photos, as: :imageable, dependent: :destroy

  has_many :reviews, dependent: :destroy

  has_and_belongs_to_many :subjects

  has_many :experiences
  has_many :events
  #has_many :events foreign_key: xyz
  has_many :qualifications
  has_many :openings
  has_many :transactions, foreign_key: :user_id
  has_one :user_cart

  geocoded_by :address, :latitude  => :lat, :longitude => :lon

  def self.address
    
  end

  def full_name
    "#{self.first_name} #{self.last_name}"
  end
end
