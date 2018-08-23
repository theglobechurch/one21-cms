class StudySerializer < ActiveModel::Serializer
  attributes :name, :slug, :description, :recording_url, :website_url,
             :passage_ref, :passage, :questions, :start, :end
  attribute :image, if: :graphic?
  attribute :images, if: :graphic?
  attribute :date, if: :return_date?
  attribute :scripture, if: :scripture?

  def name
    object.study_name
  end

  def start
    MarkdownRenderer.new.to_markdown(object.study_start)
  end

  def end
    MarkdownRenderer.new.to_markdown(object.study_end)
  end

  def passage
    object.passage_str
  end

  def scripture?
    object.scripture != [nil]
  end

  def date
    object.published_at
  end

  def return_date?
    object.guide.sorting != 'ordered'
  end

  def graphic?
    true if object.lead_image
  end

  def images
    bs = base_url
    og = object.lead_image
    ot = object.lead_image_thumbnails

    {
      'thumbnail': "#{bs}#{ot[:thumbnail]}",
      'thumbnail_2x': "#{bs}#{ot[:thumbnail_2x]}",
      '320': "#{bs}#{og[:"320"]}",
      '640': "#{bs}#{og[:"640"]}",
      '960': "#{bs}#{og[:"960"]}",
      '1280': "#{bs}#{og[:"1280"]}",
      '1920': "#{bs}#{og[:"1920"]}",
      '2560': "#{bs}#{og[:"2560"]}"
    }
  end

  def image
    "#{base_url}#{object.lead_image[:"960"]}"
  end

  def base_url
    @instance_options[:params][:base_url] if @instance_options[:params]
  end
end
