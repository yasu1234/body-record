class Knowledge < ApplicationRecord
  include Rails.application.routes.url_helpers
  has_many_attached :images
  has_many :bookmarks, dependent: :destroy
  has_many :comments, dependent: :destroy
  belongs_to :user

  validates :title, presence: true, length: { in: 1..100 }
  validates :content, length: { maximum: 5000 }, allow_blank: true

  validates :images,
            content_type: { in: %w[image/jpeg image/png image/jpg] },
            size: { less_than: 5.megabytes },
            limit: { max: 5 },
            allow_blank: true

  attr_accessor :create_date_jst

  module SortType
    BOOKMARK_COUNT = 2
  end

  scope :latest_knowledges, -> { order(created_at: :desc) }

  def image_urls
    images.map do |image|
      {
        url: "http://localhost:3000" + Rails.application.routes.url_helpers.rails_blob_path(image, only_path: true),
        id: image.id,
        filename: image.filename.to_s
      }
    end
  end

  def create_date_format
    self.create_date_jst = created_at&.in_time_zone('Asia/Tokyo').strftime("%Y-%m-%d")
  end
end
