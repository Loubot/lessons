module ApplicationHelper

	def silhouette_helper(teacher)
		teacher.profile == nil ? image_tag('silhouette.jpg', size: '125x125') : image_tag(Photo.find(teacher.profile).avatar.url, size: '125x125', class: 'pull-left results_photos front') 
	end
end
