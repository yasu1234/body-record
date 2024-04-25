class Record < ApplicationRecord
    has_many_attached :images

    has_many :comments, dependent: :destroy

    def image_urls
        images.map do |image|
          {
            url: "http://localhost:3000" + rails_blob_path(image, only_path: true),
            id: image.id,
            filename: image.filename.to_s
          }
        end
    end
end
