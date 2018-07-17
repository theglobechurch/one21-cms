class Api::V1::GuidesController < ApiController

  def index
    # ToDo: At some point add pagination into this mix:
    # https://scotch.io/tutorials/build-a-restful-json-api-with-rails-5-part-three

    guides
    if @guides.length > 0
      json_response(@guides)
    else
      raise ActionController::RoutingError.new('Not Found')
    end
  end

  def show
    guide
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
                        slug: params[:church_slug],
                        verified: true
                      })
  end

  def guide
    g = guides.find_by_slug!(params[:guide_slug])
    case g.sorting
    when 'date_desc'
      sortStatement = 'studies.published_at DESC NULLS FIRST'
    when 'date_asc'
      sortStatement = 'studies.published_at ASC NULLS FIRST'
    else
      sortStatement = 'studies.sort_order ASC'
    end

    @guide = Guide.published.
                     includes(:churches, :studies).
                     where(
                       churches: {
                         slug: params[:church_slug],
                         verified: true
                       },
                       guides: { slug: params[:guide_slug] },
                       studies: {
                         status: 'published'
                       }
                     ).
                     where(
                       "studies.published_at <= ?", DateTime.now
                     ).
                     order(sortStatement).
                     first

  end

end
