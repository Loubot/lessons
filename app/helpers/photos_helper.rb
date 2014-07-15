module PhotosHelper

	def checkProfile(id)
		if current_teacher.profile == id.to_i
			current_teacher.update_attributes(profile: nil)
		end
	end

end
