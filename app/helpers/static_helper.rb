module StaticHelper

  def get_search_results(params, subject)
    if !params[:search_position].empty? && !params[:search_subjects].empty?
      
      
      if params[:sort_by] == 'Rate: lowest first'   
        @teachers = defined?(subject.teachers) ? subject.teachers.joins(:prices, :reviews).check_if_valid.near(params[:search_position], 50) : []
      elsif params[:sort_by] == "Rate: highest first"
        @teachers = defined?(subject.teachers) ? subject.teachers.joins(:prices, :reviews).check_if_valid.near(params[:search_position], 50)
           : []
      else
        @teachers = defined?(subject.teachers) ? subject.teachers.joins(:prices, :reviews).check_if_valid.near(params[:search_position], 50) : []
      end

    elsif !params[:search_position].empty? && params[:search_subjects].empty?
      
      if params[:sort_by] == 'Rate: lowest first'
        Teacher.check_if_valid.near(params[:search_position], 50)
      elsif params[:sort_by] == 'Rate: highest first'
        Teacher.check_if_valid.near(params[:search_position], 50)
      else
        Teacher.check_if_valid.near(params[:search_position], 50)
      end          

    elsif params[:search_position].empty? && !params[:search_subjects].empty?
      

      if params[:sort_by] == 'Rate: lowest first'
        
        @teachers = defined?(subject.teachers) ? subject.teachers.joins(:prices, :reviews).check_if_valid : []
      elsif params[:sort_by] == 'Rate: highest first'
        @teachers = defined?(subject.teachers) ? subject.teachers.joins(:prices, :reviews).check_if_valid : []
      else
        p 'asdfsd'
        @teachers = defined?(subject.teachers) ? subject.teachers.joins(:prices, :reviews).check_if_valid : []
      end

    elsif params[:search_position].empty? && params[:search_subjects].empty?
      []
        
    end
  end

  def get_subject(subject)
    @subject = subject == '' ? [] : Subject.where('name ILIKE ?', "%#{subject}%").first
  end
end

