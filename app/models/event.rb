# == Schema Information
#
# Table name: events
#
#  id         :integer          not null, primary key
#  title      :string(255)
#  start_time :datetime
#  end_time   :datetime
#  status     :string(255)
#  created_at :datetime
#  updated_at :datetime
#  teacher_id :integer
#  time_off   :binary
#  student_id :integer
#  review_id  :integer
#  subject_id :integer
#

class Event < ActiveRecord::Base
  validates :teacher_id, presence: true
  validates :start_time, :end_time,  presence: :true
  validates :start_time, :end_time, :overlap => {:exclude_edges => ["start_time", "end_time"]}
  validates :start_time, date: { before: :end_time, message: 'must be after end time' }
  has_one :review
  belongs_to :teacher, touch: true
  #belongs_to :teacher, foreign_key: :student_id

  before_save :add_name, except: [:student_do_single_booking,:studentDoMultipleBookings]

  scope :student_events, ->(student_id) { where(student_id: student_id).order("end_time DESC")}

  def student_name
    Teacher.find(self.student_id).full_name
  end

  def teacher_name
    Teacher.find(self.teacher_id).full_name
  end

  def self.student_do_multiple_bookings(params)
    event_params = get_event_params(params)
    
    weeks = params[:booking_length].to_i - 1
    teacher = Teacher.find(params[:event][:teacher_id])
    for i in 0..weeks
      
      newStart = event_params[:start_time] + ((i*7).days) #add a week
      newEnd = event_params[:end_time] + ((i*7).days) #add a week
      p "startTime #{newStart}"
      p "newStart #{newEnd}"
      event = Event.new(
                          title: teacher.full_name,
                          start_time: newStart,
                          end_time: newEnd,
                          status: 'active',
                          teacher_id: params[:event][:teacher_id],
                          student_id: params[:event][:student_id]
                        )
      # e.save
      return event if !event.valid?
      
    end
    return event  
  end

  def self.student_do_single_booking(params)
    event_params = get_event_params(params)

    event = Event.new( 
                        event_params
                      )
  end

  def self.get_event_params(params)
    date = params[:date]
    { start_time: Time.zone.parse("#{date} #{params[:event]['start_time(5i)']}"),
      end_time: Time.zone.parse("#{date} #{params[:event]['end_time(5i)']}"),
      teacher_id: params[:event][:teacher_id],
      student_id: params[:event][:student_id],
      status: 'active'
     }
  end


  def self.create_confirmed_events(cart)
    if cart[:multiple] == true
      
      create_multiple_events_and_save(cart)
    else
      create_single_event_and_save(cart)
    end
  end

  

private

	def add_name #add teachers name as the title
    # puts "************ #{self.teacher_id}"
		user = Teacher.find(self.teacher_id)
		self.title = user.full_name		
	end

  def self.create_multiple_events_and_save(cart) #teachers area block booking
    ids = []
    continue = true  
    
    
    weeks = cart[:weeks].to_i - 1
    for i in 0..weeks
      newStart = cart.params[:start_time] + (i*7.days)
      newEnd = cart.params[:end_time] + (i*7.days)
      e = Event.new(
                      start_time: newStart, 
                      end_time: newEnd,                      
                      teacher_id: cart.params[:teacher_id],
                      student_id: cart.params[:student_id],
                      subject_id: cart.params[:subject_id],
                      status: 'active'
                    )
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

  def create_single_event_and_save(cart)
    Event.new(
                start_time: cart.params[:start_time],
                end_time: cart.params[:end_time],
                teacher_id: cart.params[:teacher_id],
                student_id: cart.params[:student_id],
                subject_id: cart.params[:subject_id],
                status: 'active'
              )
  end


end
