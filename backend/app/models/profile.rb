class Profile < ApplicationRecord
    belongs_to :user
    has_one_attached :image

    def image_url
        if image.attached?
            {
                url: "http://localhost:3000" + Rails.application.routes.url_helpers.rails_blob_path(image, only_path: true),
                id: image.id,
                filename: image.filename.to_s
            }
        else
            nil
        end
    end
end
