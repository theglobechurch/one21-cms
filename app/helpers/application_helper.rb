module ApplicationHelper
  def markdown(text)
    options = {
      filter_html:          true,
      hard_wrap:            true,
      link_attributes:      { rel: 'nofollow', target: "_blank" },
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

    markdown.render(text).html_safe
  end

  def gravatar_url(email, **options)
    grav = Digest::MD5.hexdigest(email.strip.downcase)
    URI("https://www.gravatar.com/avatar/" << grav).tap do |uri|
      uri.query = options.to_query
    end.to_s
  end

  def responsive_image_tag(graphic, html_options = {})
    srcset = graphic.map { |(k, v)| "#{URI.escape(v)} #{k}w" }
    kwargs = html_options.deep_merge(sizes:
      html_options.fetch(:sizes, []).join(', '))
    fallback = graphic.try(:[], :"960")
    fallback = graphic.values[0] if fallback.nil?
    image_tag URI.escape(fallback),
              srcset: srcset.join(', '),
              **kwargs
  end

  def responsive_thumbnail_tag(graphic, html_options = {})
    srcset = [
      "#{URI.escape(graphic[:thumbnail])} 200w",
      "#{URI.escape(graphic[:thumbnail_2x])} 400x",
    ]
    kwargs = html_options.deep_merge(sizes:
      html_options.fetch(:sizes, []).join(', '))
    fallback = graphic.try(:[], :"thumbnail")
    fallback = graphic.values[0] if fallback.nil?
    image_tag URI.escape(fallback),
              srcset: srcset.join(', '),
              **kwargs
  end
end
