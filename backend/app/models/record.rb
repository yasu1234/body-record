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

    scope :in_month, ->(year, month) {
      start_date = DateTime.new(year, month, 1)
      end_date = start_date.next_month
      where(date: start_date..end_date)
    }

    def self.get_month_records(year, month, user)
      start_date = DateTime.new(year, month, 1)
      end_date = start_date.next_month
     
      dates = []
      current_date = start_date
      while current_date < end_date
        dates << current_date
        current_date = current_date.next_day
      end

      records = user.records.in_month(year, month)
      records_with_empty_dates = []
      
      # 1ヶ月の記録をまとめる、なければ体重と体脂肪率が0のデータを作成(DBには保存しない)
      dates.each do |date|
        record = records.find { |r| r.date == date }
        records_with_empty_dates << (record || Record.new(date: date, weight: 0, fat_percentage: 0))
      end
      
      records_with_empty_dates
    end

    def self.search_and_paginate(params, base_records)
      records = base_records
  
      if params[:keyword].present?
        records = records.where("lower(memo) LIKE :keyword", keyword: "%#{params[:keyword]}%")
      end
  
      if params[:startDate].present?
        records = records.where("date >= ?", params[:startDate])
      end
  
      if params[:endDate].present?
        records = records.where("date <= ?", params[:endDate])
      end
  
      if params[:page].present?
        records = records.page(params[:page]).per(30)
      else
        records = records.page(1).per(30)
      end
  
      [records, records.total_pages]
    end

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

    def graph_formatted_date
      self.formatted_date = date&.strftime('%m/%d')
    end

    def formatted_date
      self.formatted_date = date&.strftime('%Y年%-m月%-d日')
    end
end
