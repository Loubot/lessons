module PhotosHelper

	def checkProfile(id) #set profile to nil after profile photo is deleted
		if current_teacher.profile == id.to_i
			current_teacher.update_attributes(profile: nil)
		end
	end

end
