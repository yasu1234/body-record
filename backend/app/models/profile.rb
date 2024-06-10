class Profile < ApplicationRecord
  belongs_to :user

  validates :profile, length: { maximum: 200 }
end
