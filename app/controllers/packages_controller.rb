class PackagesController < ApplicationController
  before_action :authenticate_teacher!


  def create
    p "params #{params}"
    p = Package.new(package_params)
    if p.save
      flash[:success] = "Package created successfully"
    else
      flash[:danger] = "Package not saved, #{p.errors.full_messages.join(',')}"
    end
    redirect_to :back
  end

  def destroy
    p = Package.find(params[:id])
    p.destroy
    redirect_to :back
  end

  private
    def package_params
      params.require(:package).permit(:subject_name, :teacher_id, :subject_id, :price, :no_of_lessons)
    end
end