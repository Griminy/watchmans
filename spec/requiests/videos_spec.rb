require 'rails_helper'

RSpec.describe VideosController, type: :request do
  
  set(:customer){ create :customer }
  set(:other_customer){ create :customer }
  set(:video){ create :video }
  set(:other_video){ create :video }

  before :all do
    10.times do
      vid = create :video
      create :hook, video: vid, video: [video, other_video].sample
    end
    5.times{ create :customer }
  end

  it 'should return valid video' do
    get video_path(video.id)
  end

  it 'should update video' do
    better_name = 'Waba Laba Dab Daaab'
    prev_count = Video.count
    patch video_path(video.id), params: { video: { name: better_name }}
    expect(video.reload.name).to eq better_name
    expect(Video.count).to eq prev_count
  end

  it 'should create video' do
    name = 'Your grandpa is dancing'
    prev_count = Video.count
    post videos_path, params: { video: { name: name, duration: 123, customer_id: customer.id }}
    expect(Video.count).to eq prev_count + 1
    expect(Video.find_by(name: name).present?).to be_truthy
  end

  it 'should destroy video' do
    prev_count = Video.count
    delete video_path(video.id)
    expect(Video.count).to eq prev_count - 1
  end

  it 'get current_watchmans' do 
    Hook.actual.update_all created_at: 1.hour.ago
    create :hook, video: video, customer: customer
    create :hook, video: other_video, customer: other_customer
    get current_watchmans_video_path(video.id)
    parsed_res = JSON.parse response.body
    expect(parsed_res['customers'].pluck('id')).to eq [customer.id]
    expect(parsed_res['count']).to eq 1
  end
end