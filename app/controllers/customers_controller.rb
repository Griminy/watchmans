class CustomersController < ApplicationController

  before_action :set_customer, only: %i(show update destroy)

  def create
    @customer = Customer.new permitted_params
    api_save customer
  end

  def show
    api_object @customer
  end

  def update
    @customer.attributes = permitted_params
    api_save @customer
  end


  # curl -XGET -H "Content-type: application/json" -d '{"customer": {"video_id": 1}}' 'localhost:3000/customers'
  def index
    @customers = Customer.where permitted_params

    if (vid_id = params[:customer][:video_id]).present?
      current_hooks = Hook.actual.where(video_id: vid_id)
      @customers = @customers.joins("INNER JOIN (#{current_hooks.to_sql}) as hooks ON (hooks.customer_id = customers.id)")
    end

    api_collection @customers.limit(100)
  end

  def destroy
    api_destroy @customer
  end

  private 

  def set_customer
    @customer = Customer.find params[:id]
  end

  def permitted_params
    params.require(:customer).permit *Customer.all_keys(except: [:id])
  end

end