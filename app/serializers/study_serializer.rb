class StudySerializer < ActiveModel::Serializer
  attributes :name, :slug, :description, :recording_url, :website_url,
             :passage_ref, :passage, :questions, :start, :end
  attribute :image, if: :has_graphic?
  attribute :images, if: :has_graphic?

  def name
    object.study_name
  end

  def start
    object.study_start
  end

  def end
    object.study_end
  end

  def passage
    object.passage_str
  end

  def has_graphic?
    true if object.graphic
  end

  def images
    {
      'thumbnail': object.graphic.graphic_thumbnail.try(:remote_url),
      'thumbnail_2x': object.graphic.graphic_thumbnail_2x.try(:remote_url),
      '320': object.graphic.graphic_320.try(:remote_url),
      '640': object.graphic.graphic_640.try(:remote_url),
      '960': object.graphic.graphic_960.try(:remote_url),
      '1280': object.graphic.graphic_1280.try(:remote_url),
      '1920': object.graphic.graphic_1920.try(:remote_url),
      '2560': object.graphic.graphic_2560.try(:remote_url),
    } if object.graphic
  end

  def image
    object.graphic.try(:graphic_960).try(:remote_url) if object.graphic
  end
end
