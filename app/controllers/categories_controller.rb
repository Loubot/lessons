class CategoriesController < ApplicationController

	def create
		@category = Category.new(category_params)
		if @category.save
			flash[:success] = "Category created successfully"
			redirect_to :back
		else
			flash[:danger] "Couldn't delete category @category.errors.full_messages"
			redirect_to :back
		end
	end

	def destroy
		@category = Category.find(params[:id])
		if @cetagory.destroy
			flash[:success] = "Category deleted successfully"
			redirect_to :back
		else
			flash[:danger] = "Couldn't delete category @category.errors.full_messages"
			redirect_to :back
		end
	end

	private
		def category_params
			params.require(:category).permit!
		end
end
