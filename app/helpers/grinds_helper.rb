module GrindsHelper
  def get_grinds_search_results(params, subject) #return list of valid teachers ordered by params
  
  p "grind params #{params}"
  params.merge!({ :search_position => '' }) if (params[:search_position].blank? || !params.has_key?(:search_position))#add search positiong if it's missing
  params.merge!({ :search_subjects => '' }) if (params[:search_subjects].blank? || !params.has_key?(:search_subjects))#add search positiong if it's missing
  
  
    if !params[:search_position].empty? && !params[:search_subjects].empty? #subject and location
      if params.has_key?(:lat)
        ids = Location.near([params['lat'].to_f, params['lon'].to_f], \
             params['distance'].to_f).select('id').map(&:teacher_id)

        

        @teachers = subject.first.teachers.check_if_valid.includes(:prices, :reviews, :subjects, :locations).where(id: ids).paginate(page: params[:page])
      else
        ids = Location.near(params[:search_position], 10).select('id').map(&:teacher_id)

        @teachers = Teacher.includes(:grinds, :prices, :reviews, :subjects, :locations).where.not(grinds: { teacher_id: nil }) \
                                                        .where(grinds: { subject_id: @subject.id })


        @teachers = subject.first.teachers.check_if_valid.includes(:prices, :reviews, :subjects, :locations)\
                                                                .where(id: ids).paginate(page: params[:page])
      
      end
      if params[:sort_by] == 'Rate: lowest first'   
        @teachers.reorder('prices.price ASC')
      elsif params[:sort_by] == "Rate: highest first"
        @teachers.reorder('prices.price DESC')
      else
        @teachers
      end

    elsif !params[:search_position].empty? && params[:search_subjects].empty? #location but not subject
      ids = Location.near([params['lat'].to_f, params['lon'].to_f], \
           params['distance'].to_f).select('id').map(&:teacher_id)
      @teachers = subject.first.teachers.check_if_valid.includes(:prices, :reviews, :subjects, :locations).where(id: ids).paginate(page: params[:page])

      if params[:sort_by] == 'Rate: lowest first'
        @teachers.reorder('prices.price ASC')
      elsif params[:sort_by] == 'Rate: highest first'
        @teachers.reorder('prices.price DESC')
      else
        @teachers
      end          

    elsif params[:search_position].empty? && !params[:search_subjects].empty? #no location and subject
       if params.has_key?(:lat)
        ids = Location.near([params['lat'].to_f, params['lon'].to_f], \
             params['distance'].to_f).select('id').map(&:teacher_id)
        @teachers = subject.first.teachers.check_if_valid.includes(:prices, :reviews, :subjects, :locations).where(id: ids).paginate(page: params[:page])
      else
        ids = Location.near(params[:search_position], 10).select('id').map(&:teacher_id)
        @teachers = subject.first.teachers.check_if_valid.includes(:prices, :reviews, :subjects, :locations).paginate(page: params[:page])
      
      end
      

      # puts 'yaya'
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
  end # end of get_grinds_search_results

  def get_select_text_for_grinds(grinds)
    grinds.collect { |g| \
     [ "#{ g.subject_name } #{ g.start_time.strftime('%d/%m/%Y @ %H:%M') } \
        #{ number_to_currency(g.price.to_f, unit: '€') }" \
      , g.id ]
    }
  end

  def level_select
    [ ['Junior cert', 'Junior cert'], ['Leaving cert', 'Leaving cert']]
  end

  def get_level_select(levels)
    levels_array = levels.collect { |l| [ l, l ] }
    p "levels array #{ levels_array }"
    levels_array
  end

end