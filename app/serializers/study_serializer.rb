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
    true if object.graphic
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

  def base_url
    @instance_options[:params][:base_url] if @instance_options[:params]
  end
end
