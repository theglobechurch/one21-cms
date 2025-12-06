require 'httparty'
require 'cgi'

class EsvClient
  include HTTParty

  base_uri 'https://api.esv.org'

  DEFAULT_PARAMS = {
    'include-css-link' => false,
    'inline-styles' => false,
    'wrapping-div' => false,
    'include-book-titles' => false,
    'include-passage-references' => false,
    'include-verse-anchors' => false,
    'include-chapter-numbers' => true,
    'include-first-verse-numbers' => true,
    'include-verse-numbers' => true,
    'include-footnotes' => false,
    'include-footnote-body' => false,
    'include-crossrefs' => false,
    'include-headings' => false,
    'include-subheadings' => false,
    'include-surrounding-chapters' => false,
    'include-audio-link' => false,
    'include-short-copyright' => false,
    'include-copyright' => false
  }.freeze

  def self.with_base_url
    new
  end

  def passage_lookup(ref, simple: true)
    params = DEFAULT_PARAMS.merge('q' => ref)

    response = self.class.get('/v3/passage/html/',
      query: params,
      headers: {
        'Content-Type' => 'application/json',
        'Authorization' => "Token #{ENV['esv_api_token']}"
      }
    )

    raise "ESV API error: #{response.code} - #{response.body}" unless response.success?

    simple ? response['passages'] : response.parsed_response
  end
end
