class ApiController < ApplicationController
  before_action :set_headers
  before_action :allow_page_caching
  include Response

  def index; end

private

  def set_headers
    # Allow GET from anywhere
    response.headers['Access-Control-Allow-Origin'] = '*'
    response.headers['Access-Control-Allow-Methods'] = 'GET'
  end

  def allow_page_caching
    expires_in(5.minutes, public: true) unless Rails.env.development?
  end

end
