# == Schema Information
#
# Table name: conversations
#
#  id            :integer          not null, primary key
#  teacher_id    :integer
#  student_id    :integer
#  teacher_email :string
#  student_email :string
#  teacher_name  :string
#  student_name  :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class MessagesController < ApplicationController

  def create
    p "Hit the MessagesController/create"
    m = Message.new( message_params )
    if m.save
      flash[:success] = "Message sent ok"

    else
      flash[:danger] = "Message not sent #{ m.errors.full_messages }"
    end

    redirect_to :back
  end

  private

    def message_params
      
      
      params.require(:message).permit(:message, :conversation_id)
    end
end
