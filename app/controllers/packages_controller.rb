class PackagesController < ApplicationController
  before_action :authenticate_teacher!


  def create
    puts "params #{params}"
    redirect_to :back
  end

  def destroy

  end

  private
    def package_params
      params.require(:package).permit!
    end
end