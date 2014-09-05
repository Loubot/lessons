module ApplicationHelper

	def silhouette_helper(teacher)
		teacher.profile == nil ? image_tag('silhouette.jpg') : image_tag(Photo.find(teacher.profile).avatar.url, class: 'pull-left results_photos front') 
	end
end
