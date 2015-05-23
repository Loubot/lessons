# == Schema Information
#
# Table name: invitations
#
#  id              :integer          not null, primary key
#  inviter_id      :integer
#  inviter_name    :string
#  recipient_email :string
#  token           :string
#  accepted        :boolean
#  accepted_at     :date
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class Invitation < ActiveRecord::Base
  validates :inviter_id, :token, :inviter_name, presence: true
  validates :recipient_email, presence: true, email: true
  belongs_to :teacher, foreign_key: 'inviter_id'

  before_validation :add_token


  def add_token
    self.token =  Digest::SHA1.hexdigest([Time.now, rand].join)
  end
end
