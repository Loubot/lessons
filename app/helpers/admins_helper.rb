module AdminsHelper

	def update_admins(admin_ids) 
		if !admin_ids.include? current_teacher.id.to_s #stop admin from removing himself from admin list
			flash[:danger] = "You can't remove yourself from Admin list"
			return
		end

		missing_ids = Teacher.where("id NOT IN (?)", admin_ids).pluck(:id) #return only ids not in new admin list
		missing_ids.each do |missing_id| #set all not adims to false
			Teacher.find(missing_id.to_i).update_attributes(admin: false) 
		end
		
		admin_ids.each do |admin| #set all admins to true
			Teacher.find(admin.to_i).update_attributes(admin: true)
		end


	end
end