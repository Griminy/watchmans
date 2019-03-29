require 'rails_helper'

RSpec.describe HooksController, type: :request do
  
  set(:customer){ create :customer }
  set(:video){ create :video }

  it 'should create hook' do
    prev_count = Hook.count
    post hooks_path, params: { hook: { video_id: video.id, customer_id: customer.id }}
    expect(Hook.count).to eq prev_count + 1
    expect(Hook.last.customer).to eq customer
    expect(Hook.last.video).to eq video
  end
end