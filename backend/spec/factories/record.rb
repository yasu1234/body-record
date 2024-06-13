FactoryBot.define do
  factory :record do
    sequence(:date) { |n| Date.today - rand(365) }
    weight { 65.1 }
    fat_percentage { 11.2 }
    memo { "サンプルメモ" }
    open_status { 1 }
    user
  end
end
