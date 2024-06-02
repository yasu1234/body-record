FactoryBot.define do
  factory :record do
    date { "2024-05-03T00:00:00.000Z" }
    weight { 65.1 }
    fat_percentage { 11.2 }
    memo { "サンプルメモ" }
    open_status { 1 }
    user
  end
end
