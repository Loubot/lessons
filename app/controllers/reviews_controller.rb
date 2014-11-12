class ReviewsController < ApplicationController
  before_action :authenticate_teacher!
  def create
    @review = Review.new(review_params)
    if @review.save
      flash[:success] = "Review created"
    else
      flash[:danger] = "Review could not be created #{@review.errors.full_messages}"
    end
    redirect_to :back
  end

  private 

    def review_params
      params.require(:review).permit!
    end

end