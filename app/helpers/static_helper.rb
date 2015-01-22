module StaticHelper  
  

  def get_subject(subject) #return first subject ILIKE name passed in
    @subject = subject == '' ? [] : Subject.where('name LIKE ?', "%#{subject}%").first
  end
end



def get_search_results(params, subject) #return list of valid teachers ordered by params
  puts "postion #{params[:search_position]}"
  
  
    if !params[:search_position].empty? && !params[:search_subjects].empty? #subject and location
      ids = Location.near(params[:search_position], 10).select('id').map(&:teacher_id)
      @teachers = subject.first.teachers.check_if_valid.includes(:prices, :reviews, :subjects).where(id: ids).paginate(page: params[:page])
      
      if params[:sort_by] == 'Rate: lowest first'   
        @teachers.reorder('prices.price ASC')
      elsif params[:sort_by] == "Rate: highest first"
        @teachers.reorder('prices.price DESC')
      else
        @teachers
      end

    elsif !params[:search_position].empty? && params[:search_subjects].empty? #location but not subject
      ids = Location.near(params[:search_position], 10).select('id').map(&:teacher_id)
      @teachers = subject.first.teachers.check_if_valid.includes(:prices, :reviews, :subjects).where(id: ids).paginate(page: params[:page])

      if params[:sort_by] == 'Rate: lowest first'
        @teachers.reorder('prices.price ASC')
      elsif params[:sort_by] == 'Rate: highest first'
        @teachers.reorder('prices.price DESC')
      else
        @teachers
      end          

    elsif params[:search_position].empty? && !params[:search_subjects].empty? #no location and subject
      # ids = Location.near(params[:search_position], 10).select('id').map(&:teacher_id)
      @teachers = subject.first.teachers.check_if_valid.includes(:prices, :reviews, :subjects).paginate(page: params[:page])

      puts 'yaya'
      if params[:sort_by] == 'Rate: lowest first'
        
        @teachers.reorder('prices.price ASC')
        
      elsif params[:sort_by] == 'Rate: highest first'        
        
        @teachers.reorder('prices.price DESC')

      else
        
        @teachers 
      end

    elsif params[:search_position].empty? && params[:search_subjects].empty? #no location or subject
      []
    else
      []
    end
  end

