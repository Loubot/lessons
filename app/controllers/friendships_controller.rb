class FriendshipsController < ApplicationController

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

  private

  def friendship_params
    params.require(:friendship).permit!
  end
end