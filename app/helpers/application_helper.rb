module ApplicationHelper

	def silhouette_helper(teacher)
    begin
		  teacher.profile == nil ? image_tag('silhouette.jpg', size: '125x125', class: 'pull-left results_photos front') : image_tag(Photo.find(teacher.profile).avatar.url, size: '125x125', class: 'pull-left results_photos front') 
    rescue
      image_tag('silhouette.jpg', size: '125x125',class: 'pull-left results_photos front')
    end
	end

  def resource_name
    :teacher
  end

  def resource
    @resource ||= Teacher.new
  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:teacher]
  end
end
