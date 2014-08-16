module ApplicationHelper

	def silhouette_helper(teacher)
		teacher.profile == nil ? image_tag('silhouette.jpg') : image_tag(Photo.find(teacher.profile).avatar.url,size: '100x100', class: 'pull-left results_photos front') 
	end
end
