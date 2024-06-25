class Contact < ApplicationRecord
  validates :content, presence: true, length: { in: 1..5000 }

  attr_accessor :formatted_create_date

  def contact_date_format
    self.formatted_create_date = created_at&.in_time_zone('Asia/Tokyo').strftime("%Y-%m-%d")
  end
end
