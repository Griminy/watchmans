class VideosController < ApplicationController

  before_action :set_video, only: %i(show update destroy current_watchmans)

  def create
    @video = Video.new permitted_params
    api_save @video
  end

  def update 
    @video.attributes = permitted_params
    api_save @video
  end

  def show
    api_object @video
  end

  def index
    @videos = Video.where permitted_params
    api_collection @videos
  end

  def destroy
    api_destroy @video
  end

  def current_watchmans
    customers_ids = Hook.actual.where(video: @video).select(:customer_id)
    @customers = Customer.where id: customers_ids
    api_success customers: @customers, count: @customers.count
  end

  private 

  def set_video
    @video = Video.find params[:id]
  end

  def permitted_params
    params.require(:video).permit *Video.all_keys(except: [:id])
  end

end