FactoryBot.define do
    factory :knowledge do
        title { "サンプルタイトル" }
        content { "サンプルコンテンツ" }
        user

        # knowledgeデータを関連付け
       trait :with_bookmark do 
        transient do
            bookmarks_count { 1 }
         end
         after(:create) do |knowledge, evaluator|
            create_list(:bookmark, evaluator.bookmarks_count, knowledge: knowledge, user: knowledge.user)
        end
    end
    end
end
