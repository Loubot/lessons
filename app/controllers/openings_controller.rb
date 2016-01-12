# == Schema Information
#
# Table name: openings
#
#  id           :integer          not null, primary key
#  mon_open     :datetime
#  mon_close    :datetime
#  tues_open    :datetime
#  tues_close   :datetime
#  wed_open     :datetime
#  wed_close    :datetime
#  thur_open    :datetime
#  thur_close   :datetime
#  fri_open     :datetime
#  fri_close    :datetime
#  sat_open     :datetime
#  sat_close    :datetime
#  sun_open     :datetime
#  sun_close    :datetime
#  teacher_id   :integer
#  created_at   :datetime
#  updated_at   :datetime
#  all_day_mon  :boolean          default(FALSE)
#  all_day_tues :boolean          default(FALSE)
#  all_day_wed  :boolean          default(FALSE)
#  all_day_thur :boolean          default(FALSE)
#  all_day_fri  :boolean          default(FALSE)
#  all_day_sat  :boolean          default(FALSE)
#  all_day_sun  :boolean          default(FALSE)
#

class OpeningsController < ApplicationController

	before_action :authenticate_teacher!

	include OpeningsHelper

	def create
		
		@opening = Opening.new(format_times(params)) #openings_helper
		if @opening.save
			flash[:success] = "Opening times updated"
			redirect_to :back
		else
			flash[:danger] = "Can't update opening times #{@opening.errors.full_messages}"
			redirect_to :back
		end
	end

	def update
		@opening = Opening.find(params[:id])
		if @opening.update_attributes(format_times(params))
			flash[:success] = "Opening times updated"
			redirect_to :back
		else
			flash[:danger] = "Can't update opening times #{@opening.errors.full_messages}"
			redirect_to :back
		end
	end

	private
		def opening_params
			params.require(:opening).permit!
		end		
end
