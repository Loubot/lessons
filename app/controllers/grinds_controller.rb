class GrindsController < ApplicationController
  before_action :authenticate_teacher!


  def index
    @grinds = Grind.all
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
    redirect_to :back and return if params[:search_subjects] == ""
    # require 'Geocoder'
    require 'will_paginate/array'   

    

    respond_to do |format|
      format.html{
        @teachers = Teacher.includes(:grinds, :locations).where.not(grinds: { teacher_id: nil } )
        ids = @teachers.collect { |t| t.id }    
        loc = Geocoder.search(params[:search_position])
        gon.initial_location = { lat: loc[0].latitude, lon: loc[0].longitude }        
        @locations = Location.where(teacher_id: ids)
        p "locations #{@locations.inspect}"
        gon.locations = @locations
        @subject = Subject.where('name ILIKE ?', "%#{ params[:search_subejcts] }").first
        @teachers = @teachers.paginate(page: params[:page])
      }
      format.js{
        @subject = Subject.where("LOWER(name) ILIKE ?", params['coords']["search_subjects"]).first

        @teachers = Teacher.includes(:grinds, :locations).where.not(grinds: { teacher_id: nil }) \
                                                        .where(grinds: { subject_id: @subject.id })
        ids = @teachers.collect { |t| t.id }
        @locations = Location.near([params['coords']['lat'].to_f, params['coords']['lon'].to_f], \
           params['coords']['distance'].to_f).where(teacher_id: ids)
        
      }
      format.json{
        @subject = Subject.where("LOWER(name) ILIKE ?", params['coords']["search_subjects"]).first

        @teachers = Teacher.includes(:grinds, :locations).where.not(grinds: { teacher_id: nil }) \
                                                        .where(grinds: { subject_id: @subject.id })
        ids = @teachers.collect { |t| t.id }
        @locations = Location.near([params['coords']['lat'].to_f, params['coords']['lon'].to_f], \
           params['coords']['distance'].to_f).where(teacher_id: ids)
        render json: { locations: @locations }
      }
    end
  end

  private
    def grind_params
      params.require(:grind).permit(:subject_id, :teacher_id, :subject_name, :capacity, \
                            :number_booked, :price, :location_id, :start_time).merge(location_name: \
                            Location.find(params[:grind][:location_id]).name )
    end
end
