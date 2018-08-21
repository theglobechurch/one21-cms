class FullChurchSerializer < ActiveModel::Serializer

  # TODO: include church logo of some form here…
  attributes :name, :slug, :email, :url
  attribute :logo, if: :logo?
  attribute :logo_sq, if: :logo?
  attribute :logo_sq_large, if: :logo?
  attribute :lead_image, if: :graphic?
  attribute :lead_images, if: :graphic?

  def name
    object.church_name
  end

  def logo?
    true if object.church_logo_sq
  end

  def graphic?
    true if object.graphic
  end

  def logo_sq
    "#{base_url}#{object.church_logo_sq_250.try(:remote_url)}"
  end

  def logo_sq_large
    "#{base_url}#{object.church_logo_sq_500.try(:remote_url)}"
  end

  def logo
    "#{base_url}#{object.church_logo_600.try(:remote_url)}"
  end

  def lead_images
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

  def lead_image
    if object.graphic
      "#{base_url}#{object.graphic.try(:graphic_960).try(:remote_url)}"
    end
  end

  def base_url
    @instance_options[:params][:base_url] if @instance_options[:params]
  end

end
