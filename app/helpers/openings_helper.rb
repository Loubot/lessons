module OpeningsHelper
  def format_times(params)
      date = Date.current()
      mon_open = Time.zone.parse("#{date} #{params[:opening]['mon_open(5i)']}")
      mon_close = Time.zone.parse("#{date} #{params[:opening]['mon_close(5i)']}")
      tues_open = Time.zone.parse("#{date} #{params[:opening]['tues_open(5i)']}")
      tues_close = Time.zone.parse("#{date} #{params[:opening]['tues_close(5i)']}")
      wed_open = Time.zone.parse("#{date} #{params[:opening]['wed_open(5i)']}")
      wed_close = Time.zone.parse("#{date} #{params[:opening]['wed_close(5i)']}")
      thur_open = Time.zone.parse("#{date} #{params[:opening]['thur_open(5i)']}")
      thur_close = Time.zone.parse("#{date} #{params[:opening]['thur_close(5i)']}")
      fri_open = Time.zone.parse("#{date} #{params[:opening]['fri_open(5i)']}")
      fri_close = Time.zone.parse("#{date} #{params[:opening]['fri_close(5i)']}")
      sat_open = Time.zone.parse("#{date} #{params[:opening]['sat_open(5i)']}")
      sat_close = Time.zone.parse("#{date} #{params[:opening]['sat_close(5i)']}")
      sun_open = Time.zone.parse("#{date} #{params[:opening]['sun_open(5i)']}")
      sun_close = Time.zone.parse("#{date} #{params[:opening]['sun_close(5i)']}")

      return { teacher_id: params[:opening][:teacher_id], mon_open: mon_open, mon_close: mon_close,
              tues_open: tues_open, tues_close: tues_close, wed_open: wed_open, wed_close: wed_close,
              thur_open: thur_open, thur_close: thur_close, fri_open: fri_open, fri_close: fri_close,
              sat_open: sat_open, sat_close: sat_close, sun_open: sun_open, sun_close: sun_close }
    end
end