module ApplicationHelper
  def markdown(text)
    MarkdownRenderer.new.to_markdown(text)
  end

  def gravatar_url(email, **options)
    grav = Digest::MD5.hexdigest(email.strip.downcase)
    URI("https://www.gravatar.com/avatar/" << grav).tap do |uri|
      uri.query = options.to_query
    end.to_s
  end

  def responsive_image_tag(graphic, html_options = {})
    srcset = graphic.map do |(k, v)|
      i = Addressable::URI.parse(v)
      "#{i.normalize}  #{k}w"
    end
    kwargs = html_options.deep_merge(sizes:
      html_options.fetch(:sizes, []).join(', '))
    fallback = graphic.try(:[], :"960")
    fallback = graphic.values[0] if fallback.nil?
    fallback = Addressable::URI.parse(fallback)
    image_tag fallback.normalize.to_s,
              srcset: srcset.join(', '),
              **kwargs
  end

  def responsive_thumbnail_tag(graphic, html_options = {})
    t200 = Addressable::URI.parse(graphic[:thumbnail])
    t400 = Addressable::URI.parse(graphic[:thumbnail_2x])
    srcset = [
      "#{t200.normalize} 200w",
      "#{t400.normalize} 400w"
    ]
    kwargs = html_options.deep_merge(sizes:
      html_options.fetch(:sizes, []).join(', '))
    fallback = graphic.try(:[], :thumbnail)
    fallback = graphic.values[0] if fallback.nil?
    fallback = Addressable::URI.parse(fallback)
    image_tag fallback.normalize.to_s,
              srcset: srcset.join(', '),
              **kwargs
  end
end
