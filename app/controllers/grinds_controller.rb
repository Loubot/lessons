# == Schema Information
#
# Table name: grinds
#
#  id            :integer          not null, primary key
#  subject_id    :integer
#  teacher_id    :integer
#  subject_name  :string
#  capacity      :integer
#  number_booked :integer          default(0)
#  price         :decimal(8, 2)    default(0.0), not null
#  start_time    :datetime
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  location_id   :integer
#  location_name :string
#

class GrindsController < ApplicationController
  before_action :authenticate_teacher!

  def create
    @grind = Grind.new(grind_params)
    if @grind.save
      flash[:success] = "Classroom created successfully"
      redirect_to :back
    else
      flash[:danger] = "Couldn't create classroom #{@grind.errors.full_messages}"
      redirect_to :back
    end
  end

  def destroy
    @grind = Grind.find(params[:id])
    @grind.destroy
  end

  private
    def grind_params
      params.require(:grind).permit!
    end
end
