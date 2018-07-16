class Api::V1::GuidesController < ApiController

  def index
    # ToDo: At some point add pagination into this mix:
    # https://scotch.io/tutorials/build-a-restful-json-api-with-rails-5-part-three

    @guides = guides
    json_response(@guides)
  end

  def show
    @guide = guide
    if @guide
      json_response(@guide, :ok, FullGuideSerializer)
    else
      raise ActionController::RoutingError.new('Not Found')
    end
  end

private

  def guides
    @guides ||= Guide.published.
                      includes(:churches).
                      where(churches: {
                        slug: params[:church_slug]
                      })
  end

  def guide
    @guide ||= Guide.published.
                     includes(:churches).
                     includes(:studies).
                     where(
                       churches: { slug: params[:church_slug] },
                       guides: { slug: params[:guide_slug] },
                       studies: { status: 'published' }
                     ).first
  end

end
