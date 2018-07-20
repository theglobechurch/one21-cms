FactoryBot.define do
  factory :church do
    church_name 'All Saints'

    sequence :email do |n|
      "admin#{n}@one21.org"
    end

    phone '01234 678901'
    url 'https://allsaintslondon.church'
    city 'London, UK'

    trait :verified do
      verified true
    end
  end
end
