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

  before_filter :get_categories

  def get_categories
    @categories = Category.includes(:subjects).all
   end

  def show
    p "Hit conversation controller/show"
    
    @conversation = Conversation.includes(:messages).find(params[:id])

    
    @messages = @conversation.messages
    @message = Message.new
    teacher_signed_in? ? @message.sender_email = current_teacher.email : false 

  end

  def create
    c = Conversation.new(conversation_params)
    p "conversation params #{ conversation_params }"
    
    if c.save      
      p "conversation id #{ c.id }"
      m = Message.new( message_params( c.id, c.student_email ), conversation_params )
      if m.save
        ConversationMailer.send_message( params[:conversation][:teacher_email],
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

    def message_params(id, student_email)
      params[:conversation].merge!(conversation_id: id, sender_email: student_email )
      
      params.require(:conversation).permit(:message, :conversation_id, :sender_email )
    end
end
