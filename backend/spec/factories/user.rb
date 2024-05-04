FactoryBot.define do
    factory :user do
        sequence :email do |n|
            "person#{n}@example.com"
        end
        password { 'Password1' }
        password_confirmation { 'Password1' }
        name { 'test' }

        # knowledgeデータを関連付け
        trait :without_knowledges do
            transient do
                knowledges_count { 0 }
            end

            after(:create) do |user, evaluator|
                create_list(:knowledge, evaluator.knowledges_count, user: user)
            end
        end
        
        # knowledgeデータを関連付ける
        trait :with_knowledges do 
            transient do
                knowledges_count { 5 }
             end
             after(:create) do |user, evaluator|
                create_list(:knowledge, evaluator.knowledges_count, user: user)
            end
        end

        # knowledgeデータを関連付ける
        trait :with_knowledges_over do 
            transient do
                knowledges_count { 7 }
             end
             after(:create) do |user, evaluator|
                create_list(:knowledge, evaluator.knowledges_count, user: user)
            end
        end

        trait :without_records do
            transient do
              records_count { 0 }
            end
            after(:create) do |user, evaluator|
                create_list(:record, evaluator.records_count, user: user)
            end
          end

        trait :with_records do
            transient do
              records_count { 5 }
            end
            after(:create) do |user, evaluator|
                create_list(:record, evaluator.records_count, user: user)
            end
          end
      
          # recordデータを7件関連付ける
          trait :with_records_over do
            transient do
              records_count { 7 }
            end
            after(:create) do |user, evaluator|
                create_list(:record, evaluator.records_count, user: user)
            end
          end
    end
end