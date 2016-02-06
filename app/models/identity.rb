# == Schema Information
#
# Table name: identities
#
#  id         :integer          not null, primary key
#  uid        :string
#  provider   :string
#  teacher_id :integer
#  created_at :datetime
#  updated_at :datetime
#

class Identity < ActiveRecord::Base
  belongs_to :teacher, touch: true
  validates :uid, :provider, :teacher_id, presence: true
  validates_uniqueness_of :uid, :scope => :provider

  def self.create_with_omniauth(auth)
    create(uid: auth['uid'], provider: auth['provider'])
  end

  def self.find_by_omniauth(auth)
    find_by(uid: auth[:uid], provider: auth[:provider])
  end

  def self.find_or_create_identity(auth)
    where(uid: auth[:uid], provider: auth[:provider]).first_or_initialize do |i|
      i.uid = auth[:uid]
      provider = auth[:provider]
      
    end
  end
end
