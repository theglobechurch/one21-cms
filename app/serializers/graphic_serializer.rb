class GraphicSerializer < ActiveModel::Serializer
  
  attributes :id, :name, :images

  def name
    object.graphic_name
  end

  def images
    {
      'thumbnail': object.graphic_thumbnail.try(:remote_url),
      'thumbnail_2x': object.graphic_thumbnail_2x.try(:remote_url),
      '320': object.graphic_320.try(:remote_url),
      '640': object.graphic_640.try(:remote_url),
      '960': object.graphic_960.try(:remote_url),
      '1280': object.graphic_1280.try(:remote_url),
      '1920': object.graphic_1920.try(:remote_url),
      '2560': object.graphic_2560.try(:remote_url),
    }
  end

end
