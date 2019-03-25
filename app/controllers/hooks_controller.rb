class HooksController < ApplicationController

  # curl -XPOST -H "Content-type: application/json" -d '{"hook": {"video_id": 1, "customer_id": 1}}' 'localhost:3000/hooks'
  def create
    @hook = Hook.new permitted_params
    api_save @hook
  end

  private

  def permitted_params
    params.require(:hook).permit *Hook.all_keys(except: [:id])
  end

end