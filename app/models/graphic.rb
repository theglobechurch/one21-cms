class Graphic < ApplicationRecord

  include HasResponsiveImage

  default_scope { order(created_at: :desc) }

  belongs_to :church,
             foreign_key: :churches_id,
             inverse_of: :graphic

  has_many :guides,
           dependent: :nullify
  has_many :studies,
           dependent: :nullify

  validates :graphic_name, presence: true

  responsive_image :graphic, validate_size: false

  def graphic_urls
    responsive_image_size_urls(:graphic)
  end

  def graphic_thumbnail_urls
    responsive_thumbnails(:graphic)
  end

end
