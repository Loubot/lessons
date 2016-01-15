# == Schema Information
#
# Table name: photos
#
#  id             :integer          not null, primary key
#  name           :string
#  imageable_id   :integer
#  imageable_type :string
#  created_at     :datetime
#  updated_at     :datetime
#  avatar         :string
#

module PhotosHelper

	def checkProfile(id) #set profile to nil after profile photo is deleted
		if current_teacher.profile == id.to_i
			current_teacher.update_attributes(profile: nil)
		end
	end

end
