FactoryBot.define do
    factory :profile do
        goal_weight { 65.1 }
        goal_fat_percentage { 11.2 }
        profile { "よろしくお願いします" }
        user
    end
end