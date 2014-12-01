module ApplicationHelper

  include ActionView::Helpers::AssetTagHelper 
  def silhouette_helper(teacher) #same as next method but for non-teacher
    begin      
      teacher.profile == nil ? image_tag('silhouette.jpg', size: '125x125', class: 'pull-left results_photos front') : image_tag(Photo.find(teacher.profile).avatar.url, size: '125x125', class: 'pull-left results_photos front') 
    rescue 
      image_tag('silhouette.jpg', size: '125x125',class: 'pull-left results_photos front')
    end
  end

  #silhoette helper for show teacher page
  def show_teacher_silhouette_helper(teacher) #return silhouette pic if teacher has no profile pic set
    begin
      teacher.profile == nil ? image_tag('silhouette.jpg', class: 'media-object') : image_tag(Photo.find(teacher.profile).avatar.url, size: '125x125', class: 'media-object')
    rescue 
      image_tag('silhouette.jpg', size: '125x125', class: 'media-object')
    end
  end

  def resource_name
    :teacher
  end

  def resource
    @resource ||= Teacher.new
  end

  def resource_class
    devise_mapping.to
  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:teacher]
  end

  def is_active_message #return missing profile info message
    if valid_teacher?
      message = current_teacher.is_teacher_valid_message
      message ? message_decider(message) : nil
    end
  end

  def message_decider(message) #display full message or mobile type message
    message = current_teacher.is_teacher_valid_message
    is_mobile? ? content_tag(:p, message, class: 'mobile_alert_message') : content_tag(:p, message, class: 'alert alert-danger active_message')
  end

  private
        def valid_teacher? #return true if teacher is signed in and is a teacher
          teacher_signed_in? && current_teacher.is_teacher
        end
end
