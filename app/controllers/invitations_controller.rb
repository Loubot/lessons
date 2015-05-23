class InvitationsController < ApplicationController
  before_action :authenticate_teacher!

  def create
    @invitation = Invitation.new(invitations_params)
    if @invitation.save
      flash[:success] = "Invitation successfully sent"
      redirect_to :back
    else
      flash[:danger] = "Couldn't send invitation #{@invitation.errors.full_messages}"
      redirect_to :back
    end
  end


  private

  def invitations_params
    params.require(:invitation).permit!
  end

end