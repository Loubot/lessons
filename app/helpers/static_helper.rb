module StaticHelper  
  

  def get_subject(subject) #return first subject IILIKE name passed in
    @subject = subject == '' ? [] : Subject.where('name ILIKE ?', "%#{subject}%").first
  end
end



def get_search_results(params, subject) #return list of valid teachers ordered by params
    if !params[:search_position].empty? && !params[:search_subjects].empty?
      
      
      if params[:sort_by] == 'Rate: lowest first'   
        @teachers = defined?(subject.teachers) ? subject.teachers.check_if_valid.includes(:prices, :reviews).near(params[:search_position], 50).order("prices.home_price ASC") : []
      elsif params[:sort_by] == "Rate: highest first"
        @teachers = defined?(subject.teachers) ? subject.teachers.check_if_valid.includes(:prices, :reviews).near(params[:search_position], 50).order("prices.home_price DESC")
           : []
      else
        @teachers = defined?(subject.teachers) ? subject.teachers.check_if_valid.includes(:prices, :reviews).near(params[:search_position], 50) : []
      end

    elsif !params[:search_position].empty? && params[:search_subjects].empty?
      
      if params[:sort_by] == 'Rate: lowest first'
        Teacher.check_if_valid.includes(:prices, :reviews).near(params[:search_position], 50).order("prices.home_price ASC")
      elsif params[:sort_by] == 'Rate: highest first'
        Teacher.check_if_valid.includes(:prices, :reviews).near(params[:search_position], 50).order("prices.home_price DESC")
      else
        Teacher.check_if_valid.includes(:prices, :reviews).near(params[:search_position], 50)
      end          

    elsif params[:search_position].empty? && !params[:search_subjects].empty?
      

      if params[:sort_by] == 'Rate: lowest first'
        ids = Location.near('cork', 10).select('id').map(&:teacher_id)
        @teachers = subject.first.teachers.check_if_valid.includes(:prices, :reviews, :subjects).where(id: ids).paginate(page: params[:page])
        @teachers.reorder('prices.price ASC')
        
      elsif params[:sort_by] == 'Rate: highest first'
        
        ids = Location.near('cork', 10).select('id').map(&:teacher_id)
        @teachers = subject.first.teachers.check_if_valid.includes(:prices, :reviews, :subjects).where(id: ids).paginate(page: params[:page])
        @teachers.reorder('prices.price DESC')
      else
        
        @teachers = defined?(subject.teachers) ? subject.teachers.check_if_valid.includes(:prices, :reviews) : []
      end

    elsif params[:search_position].empty? && params[:search_subjects].empty?
      []
    else
      []
    end
  end

