class Profile < ApplicationRecord
  belongs_to :user

  validates :profile, length: { maximum: 200 }
  validates :goal_weight, allow_nil: true, numericality: { allow_blank: true }
  validates :goal_fat_percentage, allow_nil: true, numericality: { allow_blank: true }
end
