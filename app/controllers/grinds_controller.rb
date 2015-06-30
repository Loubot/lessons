class GrindsController < ApplicationController
  before_action :authenticate_teacher!

  def create
    p "params before #{params[:grind]}"
    params[:grind].parse_time_select! :start_time
    p "params after #{params[:grind]}"
    @grind = Grind.new(grind_params)
    if @grind.save
      flash[:success] = "Classroom created successfully"
      redirect_to :back
    else
      flash[:danger] = "Couldn't create classroom #{@grind.errors.full_messages}"
      redirect_to :back
    end
  end

  def update
    @grind = Grind.find(params[:id])
    if @grind.update_attributes(grind_params)
      flash[:success] = "Updated grind ok"
    else
      flash[:danger] = "Couldn't update grind #{@grind.errors.full_messages}"
    end
    redirect_to :back
  end

  def destroy
    @grind = Grind.find(params[:id])
    @grind.destroy
    redirect_to :back
  end

  private
    def grind_params
      params.require(:grind).permit(:subject_id, :teacher_id, :subject_name, :capacity, :number_booked, :price, :location_id, :start_time)
    end
end
