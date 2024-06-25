FactoryBot.define do
  factory :record do
    sequence(:date) { |_n| Date.today - rand(100_000) }
    weight { 65.1 }
    fat_percentage { 11.2 }
    memo { "サンプルメモ" }
    open_status { 1 }
    user

    trait :fixed_date do
      date { "2024-05-03T00:00:00.000Z" }
    end
  end
end
