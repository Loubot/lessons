class UsersController < ApplicationController

  def teacher_review
    @review = Review.new
  end

  def create_review
    @review = Review.new(review_params)
    if @review.save
      flash[:success] = "Review added successfully"
      redirect_to root_path
    else
      flash[:danger] = "Couldn't create reveiw #{@review.error.full_messages}"
      redirect_to :back
    end
  end


  private
    def review_params
      params.require(:review).permit!
    end

end