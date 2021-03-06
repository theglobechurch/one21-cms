class GuidesController < ApplicationController

  before_action :authenticate_user!

  def show
    @guide = guide
    @studies = studies
  end

  def new
    @guide = Guide.unscoped.new
    @guide.church_guides.build(church_id: current_user.churches_id)
  end

  def create
    @guide = Guide.unscoped.new(guide_params)
    if @guide.save
      flash[:notice] = "Guide created"
      redirect_to @guide
    else
      render 'new'
    end
  end

  def edit
    @guide = guide
  end

  def update
    guide.attributes = guide_params
    if guide.save
      if request.headers['TriggeredBy']
        render json: {new_status: @guide.status}
      else
        flash[:notice] = 'Guide updated'
        redirect_to guide_path(guide)
      end
    end
  end

  def reorder
    if (@orders = params[:studyIds]) && @orders.present?
      @orders = JSON.parse(params[:studyIds])
      if @orders.is_a?(Array) && @orders.size.positive?
        data = {}
        @orders.each_with_index do |id, index|
          data[id] = {sort_order: index}
        end
        Study.unscoped.all.update(data.keys, data.values)
      end
    end

    render json: ['win']
  end

private

  def guides
    @guides ||= Guide.
                includes(:church_guides).
                where(church_guides: {church_id: current_user.church.id,
                                      owner: true})
  end

  def guide
    @guide ||= guides.find_by!(slug: params[:id])
  end

  def studies
    if @studies
      @studies
    else
      @studies = guide.studies.where(status: %i[draft published])
      if @guide.sorting == "date_desc"
        @studies.order('published_at DESC NULLS FIRST')
      elsif @guide.sorting == "date_asc"
        @studies.order('published_at ASC NULLS FIRST')
      else
        @studies.order(sort_order: :asc)
      end

    end
  end

  def guide_params
    params.require(:guide).permit(:guide_name,
                                  :teaser,
                                  :description,
                                  :copyright,
                                  :status,
                                  :graphics_id,
                                  :sorting,
                                  :highlight_first,
                                  church_guides_attributes: [:church_id, :owner])
  end

end
