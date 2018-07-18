FactoryBot.define do
  factory :user do
    first_name %w[Tom Dick Harry].sample
    family_name %w[Smith Jones Davis].sample

    sequence :email do |n|
      "admin#{n}@one21.org"
    end

    password 'super secure password'
    password_confirmation { password }
  end
end
