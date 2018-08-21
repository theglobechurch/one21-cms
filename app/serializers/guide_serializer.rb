class GuideSerializer < ActiveModel::Serializer

  attributes :name, :slug, :teaser, :description, :copyright, :highlight_first
  attribute :image, if: :graphic?
  attribute :images, if: :graphic?

  def name
    object.guide_name
  end

  def graphic?
    true if object.graphic
  end

  def base_url
    @instance_options[:params][:base_url] if @instance_options[:params]
  end

  def images
    if object.graphic
      bs = base_url
      og = object.graphic

      {
        'thumbnail': "#{bs}#{og.graphic_thumbnail.try(:remote_url)}",
        'thumbnail_2x': "#{bs}#{og.graphic_thumbnail_2x.try(:remote_url)}",
        '320': "#{bs}#{og.graphic_320.try(:remote_url)}",
        '640': "#{bs}#{og.graphic_640.try(:remote_url)}",
        '960': "#{bs}#{og.graphic_960.try(:remote_url)}",
        '1280': "#{bs}#{og.graphic_1280.try(:remote_url)}",
        '1920': "#{bs}#{og.graphic_1920.try(:remote_url)}",
        '2560': "#{bs}#{og.graphic_2560.try(:remote_url)}"
      }
    end
  end

  def image
    if object.graphic
      "#{base_url}#{object.graphic.try(:graphic_960).try(:remote_url)}"
    end
  end

end
