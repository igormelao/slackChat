FactoryGirl.define do
  factory :user do
    name { FFaker::Name.name }
    email { FFaker::Internet.email }
    password { FFaker::InternetSE.password }

    factory :user_with_teams do
      after(:create) do |user|
        create(:team, user: user)
      end
    end
  end
end
