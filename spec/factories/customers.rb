FactoryGirl.define do
  factory :customer do
    sequence(:login){|i| [Faker::Cannabis.strain, i].join '_' }
  end
end
