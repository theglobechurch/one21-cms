module ApplicationHelper
  def markdown(text)
    options = {
      filter_html:          true,
      hard_wrap:            true,
      link_attributes:      {rel: 'nofollow', target: "_blank"},
      space_after_headers:  true,
      fenced_code_blocks:   true
    }

    extensions = {
      autolink:           true,
      superscript:        true,
      disable_indented_code_blocks: true
    }

    renderer = Redcarpet::Render::HTML.new(options)
    markdown = Redcarpet::Markdown.new(renderer, extensions)

    # Redcarpet takes care of dealing with html safety, so it's fine
    # to disable the OutputSafety cop here… just this once
    markdown.render(text).html_safe # rubocop:disable Rails/OutputSafety
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
