class StudiesController < ApplicationController

  before_action :authenticate_user!

  def index
    @studies = studies
  end

  def show
    @study = study
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
      redirect_to guide_study_path(@guide, @study)
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
    flash[:notice] = 'Study updated'
    redirect_to guide_path(guide)
  end

private

  def studies
    @studies ||= Study.unscoped.all
  end

  def study
    @study ||= studies.find_by_slug!(params[:id])
  end

  def guides
    @guides ||= Guide.all
  end

  def guide
    @guide ||= guides.find_by_slug!(params[:guide_id])
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
                                  :graphics_id,
                                  :study_start,
                                  :study_end)
  end

end
