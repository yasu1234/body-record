class Support < ApplicationRecord
    belongs_to :user
    belongs_to :support, class_name: 'User'
end
