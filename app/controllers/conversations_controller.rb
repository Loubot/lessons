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

class ConversationsController < ApplicationController

  def show
    p "Hit conversation controller"
    
    @conversation = Conversation.includes(:messages).find(params[:id])
    
    @messages = @conversation.messages
  end

  def create
    c = Conversation.new(conversation_params)
    p "conversation params #{ conversation_params }"
    
    if c.save      
      p "conversation id #{ c.id }"
      m = Message.new( message_params( c.id ), conversation_params )

      if m.save
        ConversationMailer.send_message( params[:conversation][:student_email],
                                         c.id,
                                         m.id,
                                         m.random
                                        ).deliver_now
        flash[:success] = "Conversation created"
      else
        flash[:danger] = "Message not sent #{ m.errors.full_messages}"
      end
    else
      flash[:danger] = "Conversation not created #{ c.errors.full_messages}"
    end
    # p "Hit conversation controller/send_message"
    # ConversationMailer.send_message(params['email']).deliver_now
    # flash[:success] = "Yippee"
    redirect_to :back
  end

  private
    def conversation_params
      params.require(:conversation).permit(:teacher_id, :student_id, :teacher_email, :student_email, :teacher_name,
                                            :student_name)
    end

    def message_params(id)
      params[:conversation].merge!(conversation_id: id)
      
      params.require(:conversation).permit(:message, :conversation_id)
    end
end
