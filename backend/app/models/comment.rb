class Comment < ApplicationRecord
    belongs_to :record, optional: true
    belongs_to :knowledge, optional: true
    belongs_to :user

    validates :comment, presence: true, length: { in: 1..300 }
end
