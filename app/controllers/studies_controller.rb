class StudiesController < ApplicationController

  before_action :authenticate_user!

  def index
    @studies = studies
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

  def show
    @study = study
  end

  def edit
    @guide = guide
    @study = study
  end

  def update
    study.attributes = study_params
    if study.save
      flash[:notice] = 'Study updated'
      redirect_to guide_path(guide)
    end
  end

private

  def studies
    @studies ||= Study.all
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
                                  :passage_ref,
                                  :questions)
  end

end
