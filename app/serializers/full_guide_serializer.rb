class FullGuideSerializer < ActiveModel::Serializer

  attributes :name, :slug, :teaser, :description, :license,
             :show_scripture, :highlight_first
  attribute :image, if: :graphic?
  attribute :images, if: :graphic?

  has_many :studies

  def name
    object.guide_name
  end

  def license
    object.copyright
  end

  def description
    object.description.gsub! "\r\n\r\n", "\r\n"
    object.description.split("\r\n")
  end

  def show_scripture
    true
  end

  def graphic?
    true if object.graphic
  end

  def images
    if object.graphic
      {
        'thumbnail': object.graphic.graphic_thumbnail.try(:remote_url),
        'thumbnail_2x': object.graphic.graphic_thumbnail_2x.try(:remote_url),
        '320': object.graphic.graphic_320.try(:remote_url),
        '640': object.graphic.graphic_640.try(:remote_url),
        '960': object.graphic.graphic_960.try(:remote_url),
        '1280': object.graphic.graphic_1280.try(:remote_url),
        '1920': object.graphic.graphic_1920.try(:remote_url),
        '2560': object.graphic.graphic_2560.try(:remote_url)
      }
    end
  end

  def image
    object.graphic.try(:graphic_960).try(:remote_url) if object.graphic
  end

end
