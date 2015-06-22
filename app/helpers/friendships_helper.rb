module FriendshipsHelper


  def return_future_bookings(events, student_id)
    p "events.inspect #{events.inspect}"
    events.map { |e| e.start_time if e.start_time > Time.now && e.student_id == student_id }.compact.size
  end

  def return_past_boookings(events, student_id)
    events.map { |e| e.start_time if e.start_time < Time.now && e.student_id == student_id }.compact.size
  end
  
end