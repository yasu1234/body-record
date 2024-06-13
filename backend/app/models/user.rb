# frozen_string_literal: true

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  include DeviseTokenAuth::Concerns::User

  has_one_attached :image

  has_many :bookmarks, dependent: :destroy
  has_one :profile, dependent: :destroy

  has_many :supporting_relationships, class_name: "Support", dependent: :destroy
  has_many :supporter_relationships, class_name: "Support", foreign_key: "support_id", dependent: :destroy
  has_many :supportings, through: :supporting_relationships, source: :support
  has_many :supporters, through: :supporter_relationships, source: :user

  has_many :comments, dependent: :destroy
  has_many :records, dependent: :destroy
  has_many :knowledges, dependent: :destroy

  has_one_attached :image

  validates :image,
  content_type: { in: %w[image/jpeg image/png image/jpg] },
  size: { less_than: 5.megabytes },
  allow_blank: true

  def image_url
    return unless image.attached?

    {
      url: "http://localhost:3000" + Rails.application.routes.url_helpers.rails_blob_path(image, only_path: true),
      id: image.id,
      filename: image.filename.to_s
    }
  end

  def self.guest!
    find_or_create_by!(email: ENV["GUEST_USER_ADDRESS"]) do |user|
      user.password = SecureRandom.urlsafe_base64
      user.name = "ゲストユーザー"
      user.status = 1
    end
  end

  def support(other_user)
    supporting_relationships.find_or_create_by!(support_id: other_user.id)
  end

  def check_support_mine(target_support_user)
    self == target_support_user
  end

  def removeSupport(other_user)
    support = supporting_relationships.find_by(support_id: other_user.id)
    support&.destroy
  end
end
