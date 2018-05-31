class Api::V1::GuidesController < ApiController

  def index
    # ToDo: At some point add pagination into this mix:
    # https://scotch.io/tutorials/build-a-restful-json-api-with-rails-5-part-three

    @guides = guides
    json_response(@guides)
  end

  def show
    json_response({'response': 'nothing to see here', 'yet': true})
  end

private

  def guides
    @guides ||= Guide.joins(:churches).
                      where(churches: {
                        slug: params[:church_slug]
                      })
  end

end
