class Micropost < ApplicationRecord
  ALLOWED_CONTENT_TYPES = Settings.micropost.image_type.freeze

  belongs_to :user
  has_many_attached :images
  delegate :name, to: :user, prefix: true
  scope :recent_posts, ->{order(created_at: :desc)}
  scope :by_users_id, ->(user_ids){where user_id: user_ids}

  validates :user_id, presence: true
  validates :content, presence: true,
    length: {maximum: Settings.validate.length.length_140}
  validate :correct_image_mime_type

  # Returns a resized image for display.
  def display_image image
    image.variant(resize_to_limit: Settings.micropost.image_limit)
  end

  private

  def correct_image_mime_type
    return unless images.attached?

    images.each do |image|
      unless image.content_type.in?(ALLOWED_CONTENT_TYPES)
        errors.add(:image, :img_format)
      end
    end
  end
end
