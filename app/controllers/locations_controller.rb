class LocationsController < ApplicationController


  def create
    flash[:success] = params
    @location = Location.new(location_params)
    if @location.save
      flash[:success] = 'Location added'
      redirect_to :back
    else
      flash[:danger] = "Couldn't save location #{@location.errors.full_messages}"
      redirect_to :back
    end
  end


  private
    def location_params
      params.require(:location).permit!
    end
end