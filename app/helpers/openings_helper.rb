# == Schema Information
#
# Table name: openings
#
#  id           :integer          not null, primary key
#  mon_open     :datetime
#  mon_close    :datetime
#  tues_open    :datetime
#  tues_close   :datetime
#  wed_open     :datetime
#  wed_close    :datetime
#  thur_open    :datetime
#  thur_close   :datetime
#  fri_open     :datetime
#  fri_close    :datetime
#  sat_open     :datetime
#  sat_close    :datetime
#  sun_open     :datetime
#  sun_close    :datetime
#  teacher_id   :integer
#  created_at   :datetime
#  updated_at   :datetime
#  all_day_mon  :boolean          default(FALSE)
#  all_day_tues :boolean          default(FALSE)
#  all_day_wed  :boolean          default(FALSE)
#  all_day_thur :boolean          default(FALSE)
#  all_day_fri  :boolean          default(FALSE)
#  all_day_sat  :boolean          default(FALSE)
#  all_day_sun  :boolean          default(FALSE)
#

module OpeningsHelper
  def format_times(params) #set opening times
      date = Date.current()
      if params[:all_day_mon] == '1' 
        mon_open = Time.zone.parse("#{date} 00:00:00")
        mon_close = Time.zone.parse("#{date} 24:00:00")
        all_day_mon = true
      else
        mon_open = Time.zone.parse("#{date} #{params[:opening]['mon_open(5i)']}")
        mon_close = Time.zone.parse("#{date} #{params[:opening]['mon_close(5i)']}")
        all_day_mon = false
      end
      
      if params[:all_day_tues] == '1' 
        tues_open = Time.zone.parse("#{date} 00:00:00")
        tues_close = Time.zone.parse("#{date} 24:00:00")
        all_day_tues = true
      else
        tues_open = Time.zone.parse("#{date} #{params[:opening]['tues_open(5i)']}")
        tues_close = Time.zone.parse("#{date} #{params[:opening]['tues_close(5i)']}")
        all_day_tues = false
      end

      if params[:all_day_wed] == '1' 
        wed_open = Time.zone.parse("#{date} 00:00:00")
        wed_close = Time.zone.parse("#{date} 24:00:00")
        all_day_wed = true
      else
        wed_open = Time.zone.parse("#{date} #{params[:opening]['wed_open(5i)']}")
        wed_close = Time.zone.parse("#{date} #{params[:opening]['wed_close(5i)']}")
        all_day_wed = false
      end

      if params[:all_day_thur] == '1' 
        thur_open = Time.zone.parse("#{date} 00:00:00")
        thur_close = Time.zone.parse("#{date} 24:00:00")
        all_day_thur = true
      else
        thur_open = Time.zone.parse("#{date} #{params[:opening]['thur_open(5i)']}")
        thur_close = Time.zone.parse("#{date} #{params[:opening]['thur_close(5i)']}")
        all_day_thur = false
      end

      if params[:all_day_fri] == '1' 
        fri_open = Time.zone.parse("#{date} 00:00:00")
        fri_close = Time.zone.parse("#{date} 24:00:00")
        all_day_fri = true
      else
        fri_open = Time.zone.parse("#{date} #{params[:opening]['fri_open(5i)']}")
        fri_close = Time.zone.parse("#{date} #{params[:opening]['fri_close(5i)']}")
        all_day_fri = false
      end

      if params[:all_day_sat] == '1' 
        sat_open = Time.zone.parse("#{date} 00:00:00")
        sat_close = Time.zone.parse("#{date} 24:00:00")
        all_day_sat = true
      else
        sat_open = Time.zone.parse("#{date} #{params[:opening]['sat_open(5i)']}")
        sat_close = Time.zone.parse("#{date} #{params[:opening]['sat_close(5i)']}")
        all_day_sat = false
      end

      if params[:all_day_sun] == '1' 
        sun_open = Time.zone.parse("#{date} 00:00:00")
        sun_close = Time.zone.parse("#{date} 24:00:00")
        all_day_sun = true
      else
        sun_open = Time.zone.parse("#{date} #{params[:opening]['sun_open(5i)']}")
        sun_close = Time.zone.parse("#{date} #{params[:opening]['sun_close(5i)']}")
        all_day_sun = false
      end     

      return { teacher_id: params[:opening][:teacher_id], mon_open: mon_open, mon_close: mon_close,
              tues_open: tues_open, tues_close: tues_close, wed_open: wed_open, wed_close: wed_close,
              thur_open: thur_open, thur_close: thur_close, fri_open: fri_open, fri_close: fri_close,
              sat_open: sat_open, sat_close: sat_close, sun_open: sun_open, sun_close: sun_close,
              all_day_mon: all_day_mon, all_day_tues: all_day_tues, all_day_wed: all_day_wed,
              all_day_thur: all_day_thur, all_day_fri: all_day_fri, all_day_sat: all_day_sat,
              all_day_sun: all_day_sun }
    end
end

