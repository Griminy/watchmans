FactoryGirl.define do
  factory :video do
    name{ Faker::TvShows::RickAndMorty.character }
    duration{ rand(1000..10000) }
    customer{ create :customer }
  end
end
