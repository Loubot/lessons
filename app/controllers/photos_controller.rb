class PhotosController < ApplicationController

	def new 
		@context = context
		@photo = Photo.new	
	end

	private
		def context 
			if params[:controller] == 'teachers'
				Teacher.find(params[:id])
			end
		end
end
