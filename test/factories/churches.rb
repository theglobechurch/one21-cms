FactoryBot.define do
  factory :church do
    church_name { "All Saints" }

    sequence :email do |n|
      "admin#{n}@one21.org"
    end

    sequence :url do |n|
      "https://allsaintslondon#{n}.church"
    end

    city { "London, UK" }

    trait :verified do
      verified { true }
    end
  end
end
