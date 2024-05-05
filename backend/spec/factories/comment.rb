FactoryBot.define do
    factory :comment do
        comment { '頑張ってください！！！' }
        record
        user
    end
end