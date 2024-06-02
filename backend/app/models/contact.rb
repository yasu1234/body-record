class Contact < ApplicationRecord
  validates :content, presence: true, length: { in: 1..5000 }
end
