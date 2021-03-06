# == Schema Information
#
# Table name: events
#
#  id         :integer          not null, primary key
#  title      :string
#  start_time :datetime
#  end_time   :datetime
#  status     :string
#  created_at :datetime
#  updated_at :datetime
#  teacher_id :integer          default(0)
#  time_off   :binary
#  student_id :integer          default(0)
#  review_id  :integer
#  subject_id :integer
#

module EventsHelper  
  def format_time(params)
    date = params[:date]
    starttime = Time.zone.parse("#{date} #{params[:event]['start_time(5i)']}")
    endtime = Time.zone.parse("#{date} #{params[:event]['end_time(5i)']}")
    @event_params = { time_off: params[:event][:time_off], start_time: starttime,
                     end_time: endtime, status: 'active',
                      teacher_id: params[:event][:teacher_id], student_id: params[:event][:student_id] }
  end

  def student_format_time(params)
    date = params[:date]
    
    starttime = Time.zone.parse("#{date} #{params['start_time(5i)']}")
    # p "$$$$$$$$$$$$ #{starttime}"
    endtime = Time.zone.parse("#{date} #{params['end_time(5i)']}")
    session[:event_params] = { time_off: params[:time_off], start_time: starttime,
                     end_time: endtime, status: 'active',student_id: params[:student_id],
                      teacher_id: params[:teacher_id], subject_id: params[:subject_id]}

  end

  


  def doMultipleBookings(params) #teachers area block booking
    ids = []
    continue = true
    date = Date.parse(params[:date])
    startTime = Time.parse("#{date}, #{params[:event]['start_time(5i)']}")
    endTime = Time.parse("#{date}, #{params[:event]['end_time(5i)']}")
    puts startTime + 7.days
    puts endTime + 7.days
    weeks = params[:booking_length].to_i - 1
    for i in 0..weeks
      newStart = startTime + (i*7.days)
      newEnd = endTime + (i*7.days)
      e = Event.new(start_time: newStart, end_time: newEnd, status: 'active',
                   teacher_id: current_teacher.id)
      if e.save
        ids << e.id
      else 
        flash[:danger] = "There was a booking conflict #{e.errors.full_messages}"
        ids.each do |id|
          Event.find(id).destroy          
        end
        continue = false
        return
      end
      return unless continue
    end

  end

end
