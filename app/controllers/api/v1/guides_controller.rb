class Api::V1::GuidesController < ApiController

  def index
    # ToDo: At some point add pagination into this mix:
    # https://scotch.io/tutorials/build-a-restful-json-api-with-rails-5-part-three

    @guides = guides
    json_response(@guides)
  end

  def show
    @guide = guide
    json_response(@guide, :ok, FullGuideSerializer)
  end

private

  def guides
    @guides ||= Guide.published.
                      joins(:churches).
                      where(churches: {
                        slug: params[:church_slug]
                      })
  end

  def guide
    @guide ||= guides.find_by_slug!(params[:guide_slug])
  end

end
