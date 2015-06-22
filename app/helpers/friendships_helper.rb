module FriendshipsHelper


  def return_future_bookings(events)
    p "events.inspect #{events.inspect}"
    events.map { |e| e if e.start_time > Time.now }.size
  end

  def return_past_boookings(events)
    events.map { |e| e if e.start_time < Time.now }.size
  end


end