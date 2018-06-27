class ApiController < ApplicationController
  before_action :set_headers
  include Response
  
  def index; end

private

  def set_headers
    # Allow GET from anywhere
    response.headers['Access-Control-Allow-Origin'] = '*'
    response.headers['Access-Control-Allow-Methods'] = 'GET'
  end

end
