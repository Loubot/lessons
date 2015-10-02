class GrindsController < ApplicationController
  include GrindsHelper
  include ActionView::Helpers::NumberHelper
  before_action :authenticate_teacher!, except: [:index, :show, :return_levels, :return_matching_grinds]

  before_action :get_categories

  def  get_categories
    @categories = Category.all
  end 


  def index
    redirect_to :back and return if params[:search_subjects] == ""
    # require 'Geocoder'
    require 'will_paginate/array'      
    @subjects = Subject.where('name LIKE ?', "%#{ params[:search_subjects] }%")
    @subject = @subjects.first

    respond_to do |format|
      format.html{
         @teachers = @teachers = get_grinds_search_results(params, @subjects)
        # @teachers = Teacher.includes(:grinds, :locations).where.not(grinds: { teacher_id: nil } )
        if !params[:search_position].empty?
          ids = @teachers.collect { |t| t.id }    
          loc = Geocoder.search(params[:search_position])

          gon.initial_location = { lat: loc[0].latitude, lon: loc[0].longitude }        
          @locations = Location.near([params['lat'].to_f, params['lon'].to_f], \
                          params['distance'].to_f).select('id')
          # p "locations #{pp ids}"
          gon.locations = @locations
        end #end of if
      }

      format.js{

        @teachers = @teachers = get_grinds_search_results(params, @subjects)
        
        ids = @teachers.collect { |t| t.id }
        @locations = Location.near([params['lat'].to_f, params['lon'].to_f], \
                      params['distance'].to_f).where(teacher_id: ids)
        gon.locations = @locations
      }

      format.json{

        @subject = Subject.where("LOWER(name) LIKE ?", params['coords']["search_subjects"]).first

        @teachers = Teacher.includes(:grinds, :locations).where.not(grinds: { teacher_id: nil }) \
                                                        .where(grinds: { subject_id: @subject.id })
        ids = @teachers.collect { |t| t.id }
        @locations = Location.near([params['coords']['lat'].to_f, params['coords']['lon'].to_f], \
           params['coords']['distance'].to_f).where(teacher_id: ids)
        render json: { locations: @locations }

      }
    end #end of respond_to
  end #end of index

  def show
    redirect_to :back and return if(!params.has_key?(:teacher_id) or params[:teacher_id].empty?)
    respond_to do |format|
      format.html{

        @teacher = Teacher.includes(:locations, :grinds).find(params[:teacher_id])
        @profilePic = @teacher.photos.find { |p| p.id == @teacher.profile }.avatar.url
        subject_ids = @teacher.grinds.pluck(:subject_id).uniq
        @subjects = Subject.find(subject_ids)
        @grind_names = @teacher.grinds.collect { |g| [g.subject_name, g.subject_id] }.uniq
        @locations = @teacher.locations
        p "grinds #{pp @grind_names}"
        gon.teacher_id = @teacher.id
        gon.locations = @locations

      }

      format.js{
        @teacher = Teacher.includes(:grinds, :subjects).find(params[:teacher_id])
        @subject = @teacher.subjects.find(params[:subject_id])
        grind = @teacher.grinds.where(subject_id: params[:subject_id])
        p "Grind inspect #{ grind.inspect }"
        
        # render status: 200, nothing: true

      }
    end #end of format
      
  end #end of show

  def create
    if params[:weeks].to_i > 1
      puts "needs doing"
      flash[:success] = "yep yep"
      redirect_to :back and return
    end

    @grind = Grind.new(grind_params)
    if @grind.save
      flash[:success] = "Classroom created successfully"
      redirect_to :back
    else
      flash[:danger] = "Couldn't create classroom #{@grind.errors.full_messages}"
      redirect_to :back
    end
    
  end

  def update
    @grind = Grind.find(params[:id])
    if @grind.update_attributes(grind_params)
      flash[:success] = "Updated grind ok"
    else
      flash[:danger] = "Couldn't update grind #{@grind.errors.full_messages}"
    end
    redirect_to :back
  end

  def destroy
    @grind = Grind.find(params[:id])
    @grind.destroy
    redirect_to :back
  end

  def return_levels
    session[:grind_subject_id] = params[:subject_id]
    session[:grind_teacher_id] = params[:teacher_id]
    @teacher = Teacher.includes(:grinds).find(params[:teacher_id])
    @levels = @teacher.grinds.where(subject_id: params[:subject_id]).collect { |g| g.level }.uniq
    # p "levels #{ @levels }"
    render '/grinds/grinds_js/return_levels.js.coffee'
  end

  def return_matching_grinds
    teacher = Teacher.includes(:grinds).find(session[:grind_teacher_id])
    @grinds = teacher.grinds.where(level: params[:level], subject_id: session[:grind_subject_id])
    
    gon.grinds = get_json_grinds(@grinds)
    p "json #{ pp @json_grinds }"
    render '/grinds/grinds_js/return_calendar.js.coffee'
  end

  private
    def grind_params
      params.require(:grind).permit(:subject_id, :teacher_id, :subject_name, :capacity, \
                            :number_booked, :price, :location_id, :start_date, :weeks,\
                            :duration, :level).merge(location_name: \
                            Location.find(params[:grind][:location_id]).name )
    end

    def get_json_grinds(grinds)

      formatted_times = []
      grinds.each do |grind|
        formatted_times << {
                            text: "Subject: #{ grind.subject_name }\n" \
                            "Places left: #{ grind.number_left }\n" \
                            "Price #{ number_to_currency(grind.price, unit: '€') }",
                            textColor: 'white',
                            start_date: grind.start_date.strftime('%Y-%m-%e %H:%M'), 
                            end_date: (grind.start_date + grind.duration.minutes).strftime('%Y-%m-%e %H:%M')         
                          }
      end
      formatted_times
    end
end
