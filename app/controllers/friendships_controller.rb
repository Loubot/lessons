class FriendshipsController < ApplicationController

  before_action :authenticate_teacher!

  def create
    @friendship = current_teacher.friendships.build(teacher_id: params[:teacher_id], student_id: params[:student_id])
    if @friendship.save
      flash[:success] = "Student associated"
    else
      flash[:danger] = "Couldn't create association: #{@friendship.errors.full_messages.join(',')}"
    end

    redirect_to :back
  end

  def destroy
    @friendship = current_teacher.friendships.find(params[:id])
    @friendship.destroy
    flash[:success] = "Deleted student"
    redirect_to :back
  end

  def send_message
    TeacherMailer.delay.teacher_to_student_mail(params[:email], params[:teacher_email], params[:subject], params[:message])
    redirect_to :back
  end

  def get_modal
    p "modal params #{params}"
    @student = Teacher.find(params[:student_id])
    render 'friendships/_friendships_modal_editer.js.coffee' and return

  end

  private

  def friendship_params
    params.require(:friendship).permit(:teacher_id, :student_id)
  end
end