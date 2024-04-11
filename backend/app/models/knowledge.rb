class Knowledge < ApplicationRecord
    include Rails.application.routes.url_helpers

    has_many_attached :images
    
    def image_urls
        images.map { |image| "http://localhost:3000" + rails_blob_path(image, only_path: true) }
    end
end
