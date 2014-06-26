# == Schema Information
#
# Table name: photos
#
#  id             :integer          not null, primary key
#  name           :string(255)
#  imageable_id   :integer
#  imageable_type :string(255)
#  created_at     :datetime
#  updated_at     :datetime
#  avatar         :string(255)
#

class Photo < ActiveRecord::Base
	belongs_to :imageable, polymorphic: true
	mount_uploader :avatar, AvatarUploader
end
