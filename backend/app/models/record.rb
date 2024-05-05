class Record < ApplicationRecord
    has_many_attached :images
    has_many :comments, dependent: :destroy

    belongs_to :user

    attr_accessor :formatted_date

    validates :date, presence: true

    def image_urls
      return [] if images.blank?
        
      images.map do |image|
        {
          url: "http://localhost:3000" + Rails.application.routes.url_helpers.rails_blob_path(image, only_path: true),
          id: image.id,
          filename: image.filename.to_s
        }
        end
    end

    def set_formatted_date
      self.formatted_date = date&.strftime('%m/%d')
    end
end
