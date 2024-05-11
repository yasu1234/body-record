class Record < ApplicationRecord
    has_many_attached :images
    has_many :comments, dependent: :destroy

    belongs_to :user

    attr_accessor :formatted_date

    validates :date, presence: true
    validates :weight, numericality: { allow_nil: true }
    validates :fat_percentage, numericality: { allow_nil: true }

    validates :images,
    content_type: { in: %w[image/jpeg image/png image/jpg] },
    size: { less_than: 5.megabytes },
    limit: { max: 3 }

    scope :latest_records, ->(limit) { order(date: :desc).limit(limit) }

    # １ヶ月の記録をまとめる、なければ体重と体脂肪率が0のデータを作成(DBには保存しない)
    scope :records_in_month, ->(dates) {
      records = all.to_a
      dates.map do |date|
        record = records.find { |r| r.date == date }
        record || new(date: date, weight: 0, fat_percentage: 0)
      end
    }

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
