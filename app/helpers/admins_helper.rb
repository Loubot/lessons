module AdminsHelper

	def update_admins(admin_ids)
		if !admin_ids.include? current_teacher.id.to_s
			flash[:danger] = "You can't remove yourself from Admin list"
			return
		end

		missing_ids = Teacher.where("id NOT IN (?)", admin_ids).pluck(:id)
		missing_ids.each do |missing_id|
			Teacher.find(missing_id.to_i).update_attributes(admin: false)
		end
		
		admin_ids.each do |admin| 
			Teacher.find(admin.to_i).update_attributes(admin: true)
		end


	end
end