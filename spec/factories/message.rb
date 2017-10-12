FactoryGirl.define do
  factory :message do
    body { FFaker::Lorem.sentence }
    user
    association :messagable, factory: :channel
  end
end
