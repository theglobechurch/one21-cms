class GuidesController < ApplicationController

  before_action :authenticate_user!

  def index
    # List all of the guide by this church
    @guides = guides
  end

  def show
    @guide = guide
    @studies = studies
  end

  def new
    @guide = Guide.unscoped.new
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
      flash[:notice] = 'Guide updated'
      redirect_to guide_path(guide)
    end
  end

  def reorder
    if (@orders = params[:studyIds]) && (@orders.present?)
      @orders = JSON.parse(params[:studyIds])
      if @orders.kind_of?(Array) && @orders.size > 0
        data = {}
        @orders.each_with_index do |id, index|
          data[id] = { sort_order: index }
        end
        Study.all.update(data.keys, data.values)
      end
    end

    render json: ['win']
  end

private

  def guides
    @guides ||= Guide.joins(:church_guides).
                      where(church_guides: {
                        church_id: current_user.church.id,
                        owner: true
                      })
  end

  def guide
    @guide ||= guides.find_by_slug!(params[:id])
  end

  def studies
    if @studies
      @studies
    else
      @studies = guide.studies.unscoped.where(status: [:draft, :published])
      if @guide.sorting == "date_desc"
        @studies.order(created_at: :desc)
      elsif @guide.sorting == "date_asc"
        @studies.order(created_at: :asc)
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
                                  :sorting)
  end

end
