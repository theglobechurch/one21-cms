class BibleController < ApplicationController
  before_action :authenticate_user!

  def index
    lookup = passage_params.join(',')
    esv = EsvClient.with_base_url
    @passages = esv.passage_lookup(lookup)
    render json: @passages
  end

private

  def passage_params
    params.require(:passages)
  end

end
