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
end
