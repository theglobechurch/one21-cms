require 'cgi'
require 'faraday_middleware/multi_json'

class EsvClient

  FARADAY_CONFIG = proc do |f|
    f.request :multi_json
    f.response :multi_json

    f.params['include-css-link'] = false
    f.params['inline-styles'] = false
    f.params['wrapping-div'] = false
    f.params['include-book-titles'] = false
    f.params['include-passage-references'] = false
    f.params['include-verse-anchors'] = false
    f.params['include-chapter-numbers'] = true
    f.params['include-first-verse-numbers'] = true
    f.params['include-verse-numbers'] = true
    f.params['include-footnotes'] = false
    f.params['include-footnote-body'] = false
    f.params['include-crossrefs'] = false
    f.params['include-headings'] = false
    f.params['include-subheadings'] = false
    f.params['include-surrounding-chapters'] = false
    f.params['include-audio-link'] = false
    f.params['include-short-copyright'] = false
    f.params['include-copyright'] = false

    f.headers['Content-Type'] = 'application/json'
    f.headers['Authorization'] = "Token #{ENV['esv_api_token']}"
    f.response :raise_error
    f.adapter Faraday.default_adapter
  end

  def self.with_base_url
    new Faraday.new(url: "https://api.esv.org/", &FARADAY_CONFIG)
  end

  def initialize(conn)
    @conn = conn
  end

  attr_reader :conn

  def passage_lookup(ref, simple: true)
    response = conn.get("v3/passage/html/?q=#{ref}").body

    if simple == true
      response['passages']
    end
  end

end
