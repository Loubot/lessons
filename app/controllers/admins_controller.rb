class AdminsController < ApplicationController

	include AdminsHelper
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
		@teachers = Teacher.where(is_teacher: true)
	end

	def make_admin
		flash[:notice] = params
		(params[:teacher] && params[:teacher][:admin]) ? admins = params[:teacher][:admin] : admins = []
		update_admins(admins)
		redirect_to :back		
	end
end