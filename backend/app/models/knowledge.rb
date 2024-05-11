class Knowledge < ApplicationRecord
    include Rails.application.routes.url_helpers
    has_many_attached :images
    has_many :bookmarks, dependent: :destroy
    has_many :comments, dependent: :destroy
    belongs_to :user

    validates :title, presence: true, length: { in: 1..100 }
    validates :content, length: { maximum: 5000 }, allow_blank: true

    validates :images, attached: true,
    content_type: { in: %w[image/jpeg image/png image/jpg] },
    size: { less_than_or_equal_to: 5.megabytes },
    limit: { max: 5 }

    def image_urls
      images.map do |image|
        {
          url: "http://localhost:3000" + Rails.application.routes.url_helpers.rails_blob_path(image, only_path: true),
          id: image.id,
          filename: image.filename.to_s
        }
      end
    end
  end
