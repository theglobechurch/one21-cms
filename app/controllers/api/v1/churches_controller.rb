class Api::V1::ChurchesController < ApiController

  def index
    # TODO: At some point add pagination into this mix:
    # https://scotch.io/tutorials/build-a-restful-json-api-with-rails-5-part-three

    @churches = Church.verified
    json_response(@churches)
  end

  def show
    @church = church
    json_response(@church, :ok, FullChurchSerializer)
  end

private

  def churches
    @churches ||= Church.verified
  end

  def church
    @church ||= churches.find_by!(slug: params[:church_slug])
  end

end
