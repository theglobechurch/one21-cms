require 'test_helper'
require 'webmock/minitest'

class EsvClientTest < ActiveSupport::TestCase
  setup do
    @client = EsvClient.with_base_url
    @esv_token = ENV['esv_api_token']
  end

  test "passage_lookup returns passages array when simple is true" do
    stub_esv_request('John 3:16', passages: ['<p>For God so loved...</p>'])

    result = @client.passage_lookup('John 3:16', simple: true)

    assert_equal ['<p>For God so loved...</p>'], result
  end

  test "passage_lookup returns full response when simple is false" do
    stub_esv_request('John 3:16',
      passages: ['<p>For God so loved...</p>'],
      query: 'John 3:16',
      canonical: 'John 3:16'
    )

    result = @client.passage_lookup('John 3:16', simple: false)

    assert_equal ['<p>For God so loved...</p>'], result['passages']
    assert_equal 'John 3:16', result['query']
    assert_equal 'John 3:16', result['canonical']
  end

  test "passage_lookup sends correct query parameters" do
    stub = stub_request(:get, "https://api.esv.org/v3/passage/html/")
      .with(
        query: hash_including('q' => 'Romans 8:28', 'include-headings' => 'false'),
        headers: {
          'Authorization' => "Token #{@esv_token}",
          'Content-Type' => 'application/json'
        }
      )
      .to_return(status: 200, body: { passages: ['test'] }.to_json)

    @client.passage_lookup('Romans 8:28')

    assert_requested stub
  end

  test "passage_lookup raises error on API failure" do
    stub_request(:get, "https://api.esv.org/v3/passage/html/")
      .with(query: hash_including('q' => 'John 3:16'))
      .to_return(status: 401, body: { error: 'Unauthorized' }.to_json)

    error = assert_raises(RuntimeError) do
      @client.passage_lookup('John 3:16')
    end

    assert_match /ESV API error: 401/, error.message
  end

  test "passage_lookup handles special characters in reference" do
    stub_esv_request('1 Corinthians 13:4-7', passages: ['<p>Love is patient...</p>'])

    result = @client.passage_lookup('1 Corinthians 13:4-7', simple: true)

    assert_equal ['<p>Love is patient...</p>'], result
  end

  private

  def stub_esv_request(reference, response_body)
    stub_request(:get, "https://api.esv.org/v3/passage/html/")
      .with(query: hash_including('q' => reference))
      .to_return(
        status: 200,
        body: response_body.to_json,
        headers: { 'Content-Type' => 'application/json' }
      )
  end
end
