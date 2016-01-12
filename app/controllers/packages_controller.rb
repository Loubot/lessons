# == Schema Information
#
# Table name: packages
#
#  id            :integer          not null, primary key
#  subject_name  :string           default("")
#  teacher_id    :integer
#  subject_id    :integer
#  price         :decimal(, )      default(0.0)
#  no_of_lessons :integer          default(0)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  duration      :integer          default(0)
#

class PackagesController < ApplicationController
  before_action :authenticate_teacher!


  def create
    # p "params #{params}"
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
    flash[:success] = "Successfully deleted package"
    redirect_to :back
  end

  private
    def package_params
      params.require(:package).permit(:subject_name, :teacher_id, :subject_id, :price, :duration, :no_of_lessons)
    end
end
