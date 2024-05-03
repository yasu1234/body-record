FactoryBot.define do
    factory :knowledge do
        title { "サンプルタイトル" }
        content { "サンプルコンテンツ" }
        user
    end
end