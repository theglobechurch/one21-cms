class Graphic < ApplicationRecord

  include HasResponsiveImage

  default_scope { order(created_at: :desc) }

  belongs_to :church,
             foreign_key: :churches_id

  has_many :guides
  has_many :studies

  validates :graphic_name, presence: true

  responsive_image :graphic, validate_size: false

  def graphic_urls
    responsive_image_size_urls(:graphic)
  end

end
