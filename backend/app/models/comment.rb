class Comment < ApplicationRecord
    belongs_to :record, optional: true
    belongs_to :knowledge, optional: true
    belongs_to :user
end
