FactoryGirl.define do
  factory :hook do
    video{ create :video }
    customer{ create :customer }
  end
end
