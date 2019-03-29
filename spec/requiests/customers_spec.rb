require 'rails_helper'

RSpec.describe CustomersController, type: :request do
  
  set(:customer){ create :customer }
  set(:other_customer){ create :customer }
  set(:other_weird_guy){ create :customer }
  set(:video){ create :video }

  before :all do
    10.times do
      vid = create :video
      create :hook, video: vid, customer: [customer, other_customer].sample
    end
    5.times{ create :hook }
  end

  it 'should return valid customer' do
    get customer_path(customer.id)
  end

  it 'should update customer' do
    new_guy_logn = 'dragon_born_returns'
    prev_count = Customer.count
    patch customer_path(customer.id), params: { customer: { login: new_guy_logn }}
    expect(customer.reload.login).to eq new_guy_logn
    expect(Customer.count).to eq prev_count
  end

  it 'should create customer' do
    new_guy_logn = 'dragon_born'
    prev_count = Customer.count
    post customers_path, params: { customer: { login: new_guy_logn }}
    expect(Customer.count).to eq prev_count + 1
    expect(Customer.find_by(login: new_guy_logn).present?).to be_truthy
  end

  it 'should destroy customer' do
    prev_count = Customer.count
    delete customer_path(customer.id)
    expect(Customer.count).to eq prev_count - 1
  end

  it 'should get is_watching_now video == true' do 
    Hook.actual.update_all created_at: 1.hour.ago
    create :hook, video: video, customer: customer
    get is_watching_now_customer_path(video.id), params: { customer: { video_id: video.id } }
    parsed_res = JSON.parse response.body
    expect(parsed_res['result']).to eq true
  end

  it 'should get is_watching_now video == false' do 
    Hook.actual.update_all created_at: 1.hour.ago
    get is_watching_now_customer_path(video.id), params: { customer: { video_id: video.id } }
    parsed_res = JSON.parse response.body
    expect(parsed_res['result']).to eq false
  end

  it 'should filter by video' do 
    needed_guys = [customer, other_customer]
    needed_guys.each{ |c| create :hook, customer: c, video: video }
    get customers_path, params: { customer: { video_id: video.id } }
    parsed_res = JSON.parse response.body
    expect(parsed_res['success']).to be_truthy
    expect(parsed_res['collection'].pluck('id')).to eq needed_guys.pluck(:id)
  end
end