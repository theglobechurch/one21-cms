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
    @studies ||= guide.studies.where(status: [:draft, :published])
  end

  def guide_params
    params.require(:guide).permit(:guide_name,
                                  :teaser,
                                  :description,
                                  :copyright,
                                  :status)
  end

end
