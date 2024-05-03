FactoryBot.define do
    factory :user do
        sequence :email do |n|
            "person#{n}@example.com"
        end
        password { 'Password1' }
        password_confirmation { 'Password1' }
        name { 'test' }

        # knowledgeデータを関連付けない
        trait :without_knowledges do
            transient do
                knowledges_count { 0 }
            end
        end
        
        # knowledgeデータを関連付ける
        trait :with_knowledges do 
            transient do
                knowledges_count { 5 }
             end
        end
      
        # 作成後にknowledgeデータの関連付け
        after(:create) do |user, evaluator|
            create_list(:knowledge, evaluator.knowledges_count, user: user)
        end
    end
end