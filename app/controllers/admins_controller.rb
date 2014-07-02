class AdminsController < ApplicationController

	include AdminsHelper
	before_action :set_admin

	def set_admin
		Teacher.find(1).update_attributes(admin: true)
	end

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
		(params[:teacher] && params[:teacher][:admin]) ? admins = params[:teacher][:admin] : admins = []
		update_admins(admins)
	end
end