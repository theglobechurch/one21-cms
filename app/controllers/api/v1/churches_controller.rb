class Api::V1::ChurchesController < ApiController

  def index
    @churches = Church.all
    json_response(@churches)
  end

end
