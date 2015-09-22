class GrindsController < ApplicationController
  include GrindsHelper
  before_action :authenticate_teacher!, except: [:index, :show]

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
        end
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
    end
  end

  def show
    redirect_to :back and return if(!params.has_key?(:teacher_id) or params[:teacher_id].empty?)
    respond_to do |format|
      format.html{

        @teacher = Teacher.includes(:locations, :grinds).find(params[:teacher_id])
        @profilePic = @teacher.photos.find { |p| p.id == @teacher.profile }.avatar.url
        subject_ids = @teacher.grinds.pluck(:subject_id).uniq
        @subjects = Subject.find(subject_ids)
        @locations = @teacher.locations
        p "locations #{pp @locations}"
        gon.locations = @locations

      }

      format.js{
        

      }
      
  end

  def create
    
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

  def grinds_search
    
  end

  private
    def grind_params
      params.require(:grind).permit(:subject_id, :teacher_id, :subject_name, :capacity, \
                            :number_booked, :price, :location_id, :start_time).merge(location_name: \
                            Location.find(params[:grind][:location_id]).name )
    end
end
