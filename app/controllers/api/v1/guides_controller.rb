class Api::V1::GuidesController < ApiController

  def index
    # TODO: At some point add pagination into this mix:
    # https://scotch.io/tutorials/build-a-restful-json-api-with-rails-5-part-three

    guides
    if @guides.length.positive?
      json_response(@guides,
                    base_url: request.base_url)
    else
      raise ActionController::RoutingError, 'Not Found'
    end
  end

  def show
    guide
    if @guide
      json_response(@guide,
                    :ok,
                    FullGuideSerializer,
                    base_url: request.base_url)
    else
      raise ActionController::RoutingError, 'Not Found'
    end
  end

private

  def guides
    @guides ||= Guide.
                published.
                includes(:churches).
                where(churches: {slug: params[:church_slug],
                                 verified: true})
  end

  def guide
    g = guides.find_by!(slug: params[:guide_slug])
    return unless g
    sort_statement = case g.sorting
                     when 'date_desc'
                       'studies.published_at DESC NULLS FIRST'
                     when 'date_asc'
                       'studies.published_at ASC NULLS FIRST'
                     else
                       'studies.sort_order ASC'
                     end

    @guide = Guide.published.
             includes(:churches, :studies).
             where(
               churches: {
                 slug: params[:church_slug],
                 verified: true
               },
               guides: {slug: params[:guide_slug]},
               studies: {status: 'published'}
             ).
             where(
               "studies.published_at <= ?", Time.now.utc
             ).
             order(sort_statement).
             first
  end

end
