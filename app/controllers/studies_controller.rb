class StudiesController < ApplicationController

  before_action :authenticate_user!

  def show
    redirect_to guide_path(guide)
  end

  def new
    @guide = guide
    @study = @guide.studies.build
  end

  def create
    @guide = guide
    @study = @guide.studies.new(study_params)
    if @study.save
      flash[:notice] = 'Study created'
      redirect_to guide_path(@guide)
    else
      render 'new'
    end
  end

  def edit
    @guide = guide
    @study = study
  end

  def update
    @study = study
    @study.update(study_params)

    if request.headers['TriggeredBy']
      render json: {new_status: @study.state, published: @study.published_at}
    else
      flash[:notice] = 'Study updated'
      redirect_to guide_path(guide)
    end
  end

private

  def studies
    @studies ||= Study.unscoped.all
  end

  def study
    @study ||= studies.find_by!(slug: params[:id])
  end

  def guides
    @guides ||= Guide.
                includes(:church_guides).
                where(church_guides: {church_id: current_user.church.id,
                                      owner: true})
  end

  def guide
    @guide ||= guides.find_by!(slug: params[:guide_id])
  end

  def study_params
    params.require(:study).permit(:study_name,
                                  :description,
                                  :sort_order,
                                  :recording_url,
                                  :website_url,
                                  :passage_ref_json,
                                  :questions_json,
                                  :status,
                                  :published_at,
                                  :graphics_id,
                                  :study_start,
                                  :study_end)
  end

end
