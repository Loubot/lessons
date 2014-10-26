module StaticHelper

  def get_search_results(params)
    if !params[:search_position].empty? && !params[:search_subjects].empty?
      @subject = get_subject(params[:search_subjects])
      
      if params[:sort_by] == 'Rate: lowest first'        
        @teachers = defined?(@subject.teachers) ? @subject.teachers.near(params[:search_position], 50).reorder('rate ASC') : []
      elsif params[:sort_by] == "Rate: highest first"
        @teachers = defined?(@subject.teachers) ? @subject.teachers.near(params[:search_position], 50).reorder('rate DESC')
           : []
      else
        @teachers = defined?(@subject.teachers) ? @subject.teachers.near(params[:search_position], 50) : []
      end

    elsif !params[:search_position].empty? && params[:search_subjects].empty?
      
      if params[:sort_by] == 'Rate: lowest first'
        Teacher.near(params[:search_position], 50).reorder('rate ASC')
      elsif params[:sort_by] == 'Rate: highest first'
        Teacher.near(params[:search_position], 50).reorder('rate DESC')
      else
        Teacher.near(params[:search_position], 50)
      end          

    elsif params[:search_position].empty? && !params[:search_subjects].empty?
      @subject = get_subject(params[:search_subjects])

      if params[:sort_by] == 'Rate: lowest first'
        @teachers = defined?(@subject.teachers) ? @subject.teachers.order('rate ASC') : []
      elsif params[:sort_by] == 'Rate: highest first'
        @teachers = defined?(@subject.teachers) ? @subject.teachers.order('rate DESC') : []
      else
        @teachers = defined?(@subject.teachers) ? @subject.teachers : []
      end

    elsif params[:search_position].empty? && params[:search_subjects].empty?
      []
        
    end
  end

  def get_subject(subject)
    @subject = subject == '' ? [] : Subject.where('name ILIKE ?', "%#{subject}%").first
  end

  def display_subjects(subjects)
    subjects.map { |s| s.name }
  end
end

