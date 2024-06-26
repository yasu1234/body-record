class Comment < ApplicationRecord
  belongs_to :record, optional: true
  belongs_to :knowledge, optional: true
  belongs_to :user

  validates :comment, presence: true, length: { in: 1..300 }

  attr_accessor :comment_create_date

  def comment_date_format
    self.comment_create_date = created_at&.in_time_zone("Asia/Tokyo")&.strftime("%Y-%m-%d %H:%M")
  end
end
