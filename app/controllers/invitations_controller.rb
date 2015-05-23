class InvitationsController < ApplicationController
  before_action :authenticate_teacher!

  def create
    @invitation = Invitation.new(invitations_params)

    if @invitation.save
      p "url1 #{URI.escape("localhost:3000#{teach_path}?inviter_id=#{@invitation.token}")}"
      MembershipMailer.send_invite(current_teacher.email, @invitation, (URI.escape("localhost:3000#{teach_path}?inviter_id=#{@invitation.token}"))).deliver_now
      flash[:success] = "Invitation successfully sent"
      redirect_to URI.escape("localhost:3000#{teach_path}?inviter_id:#{@invitation.token}")
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