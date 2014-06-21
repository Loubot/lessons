class TeachersController < ApplicationController
	before_action :authenticate_teacher!, except: [:how_it_works]

	def how_it_works

	end
end
