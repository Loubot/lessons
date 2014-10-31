# == Schema Information
#
# Table name: identities
#
#  id         :integer          not null, primary key
#  uid        :string(255)
#  provider   :string(255)
#  teacher_id :integer
#  created_at :datetime
#  updated_at :datetime
#

class Identity < ActiveRecord::Base
  belongs_to :teacher
  validates :uid, :provider, :teacher_id, presence: true


  def self.create_with_omniauth(auth)
    create(uid: auth[:uid], provider: auth[:provider])
  end

  def self.find_by_omniauth(auth)
    find_by(uid: auth[:uid], provider: auth[:provider])
  end
end
