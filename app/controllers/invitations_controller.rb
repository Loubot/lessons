# == Schema Information
#
# Table name: invitations
#
#  id              :integer          not null, primary key
#  inviter_id      :integer
#  inviter_name    :string
#  recipient_email :string
#  token           :string
#  accepted        :boolean
#  accepted_at     :date
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class InvitationsController < ApplicationController
  before_action :authenticate_teacher!

  def create
    @invitation = Invitation.new(invitations_params)

    if @invitation.save
      p "url1 #{URI.escape("localhost:3000#{teach_path}?inviter_id=#{@invitation.token}")}"
      MembershipMailer.delay.send_invite_to_teacher(current_teacher, @invitation, (URI.escape("#{teach_url}?inviter_token=#{@invitation.token}&invited_email=#{@invitation.recipient_email}")))
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
