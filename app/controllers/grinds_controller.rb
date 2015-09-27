class GrindsController < ApplicationController
  include GrindsHelper
  before_action :authenticate_teacher!, except: [:index, :show, :return_available_grinds, :select_grind, :check_and_start_payment]

  before_action :get_categories

  def  get_categories
    @categories = Category.all
  end 


  def index
    redirect_to :back and return if params[:search_subjects] == ""
    # require 'Geocoder'
    require 'will_paginate/array'      
    @subjects = Subject.where('name ILIKE ?', "%#{ params[:search_subjects] }%")
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

        @subject = Subject.where("LOWER(name) ILIKE ?", params['coords']["search_subjects"]).first

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
      
  end #of show

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

  def return_available_grinds
    @grinds = Grind.where(teacher_id: params[:teacher_id], subject_id: params[:subject_id]).available
    # pp @grinds
    render 'grinds/grinds_js/check_grind_availability.js.coffee'
  end

  def select_grind
    @grind = Grind.find(params[:grind_id])
    # pp @grind
    render 'grinds/grinds_js/return_selected_grind.js.coffee'
  end

  def check_and_start_payment
    grind = Grind.find(params[:id])
    pp grind
    if grind.number_left - params[:quantity].to_i >= 0
      pp "hoorray"
    end
    render 'grinds/grinds_js/grinds_paymant_form.js.coffee'
  end

  private
    def grind_params
      params.require(:grind).permit(:subject_id, :teacher_id, :subject_name, :capacity, \
                            :number_booked, :price, :location_id, :start_time).merge(location_name: \
                            Location.find(params[:grind][:location_id]).name )
    end
end
