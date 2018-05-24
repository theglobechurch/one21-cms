class Api::V1::ChurchesController < ApiController

  def index
    # ToDo: At some point add pagination into this mix:
    # https://scotch.io/tutorials/build-a-restful-json-api-with-rails-5-part-three
    
    @churches = Church.all
    json_response(@churches)
  end

end
