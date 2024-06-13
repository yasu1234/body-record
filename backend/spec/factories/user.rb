FactoryBot.define do
  factory :user do
    sequence :email do |n|
      "person#{n}@example.com"
    end
    password { "Password1" }
    password_confirmation { "Password1" }
    name { "test" }

    trait :fixed_id do
      id { 100 }
    end

      # knowledgeデータを関連付け
    trait :without_knowledges do
      transient do
        knowledges_count { 0 }
      end

      after(:create) do |user, evaluator|
        create_list(:knowledge, evaluator.knowledges_count, user:)
      end
    end

      # knowledgeデータを関連付ける
    trait :with_knowledges do
      transient do
        knowledges_count { 5 }
      end
      after(:create) do |user, evaluator|
        create_list(:knowledge, evaluator.knowledges_count, user:)
      end
    end

    trait :with_knowledges_over do
      transient do
        knowledges_count { 7 }
      end
      after(:create) do |user, evaluator|
        create_list(:knowledge, evaluator.knowledges_count, user:)
      end
    end

      # recordデータを関連付ける
    trait :without_records do
      transient do
        records_count { 0 }
      end
      after(:create) do |user, evaluator|
        create_list(:record, evaluator.records_count, user:)
      end
    end

    trait :with_records do
      transient do
        records_count { 5 }
      end
      after(:create) do |user, evaluator|
        create_list(:record, evaluator.records_count, user:)
      end
    end

    trait :with_records_over do
      transient do
        records_count { 7 }
      end
      after(:create) do |user, evaluator|
        create_list(:record, evaluator.records_count, user:)
      end
    end

    trait :with_supporting do
      after(:create) do |user, _evaluator|
        other_user = create(:user)
        user.support!(other_user)
      end
    end

    trait :with_profile do
      after(:create) do |user, _evaluator|
        create(:profile, user:)
      end
    end
  end

  factory :support do
    association :user
    association :support, factory: :user
  end
end
