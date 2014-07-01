module AdminsHelper

	def update_admins(admin_ids)
		if !admin_ids.include? current_teacher.id.to_s
			flash[:danger] = "You can't remove yourself from Admin list"
			return
		end

		all_ids = Teacher.pluck(:id)
		puts "%%%%%%%%%%%%%%#{all_ids}"
		admin_ids.each do |admin| 
			Teacher.find(admin.to_i).update_attributes(admin: true)
		end


	end
end