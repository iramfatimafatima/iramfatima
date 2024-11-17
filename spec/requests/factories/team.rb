FactoryBot.define do
    factory :team do
      name { "Test Team" }
      description { "A test team" }
      association :owner, factory: :user
    end
  end
  