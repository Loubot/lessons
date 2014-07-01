class AdminsController < ApplicationController
	before_action :is_admin?

	def is_admin?
		if !current_teacher.try(:admin?)
			flash[:warning] = "Tut tut. You are not an admin"
			redirect_to root_path
		end
	end

	def admin_panel
		@category = Category.new
		@categories = Category.all
		@subject = Subject.new
		@teachers = Teacher.all
	end

	def make_admin
		flash[:notice] = params
		redirect_to :back
	end
end