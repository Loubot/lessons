class IdentitiesController < ApplicationController
  before_action :authenticate_teacher!

  def destroy
    @identity = Identity.find(params[:id])
    if @identity.destroy
      flash[:success] = "Authentication metod removed"
      redirect_to :back
    else
      flash[:success] = "Couldn't destroy authentication #{@identity.errors.full_messages}"
      redirect_to :back
    end
  end
end