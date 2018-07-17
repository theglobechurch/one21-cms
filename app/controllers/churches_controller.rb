class ChurchesController < ApplicationController

  before_action :authenticate_user!

  def index
    # if super admin list all the church
    if current_user.superadmin?
      @churches = churches
    else
      if current_user.churches_id
        redirect_to root_path
      else
        redirect_to new_church_url
      end
    end
  end

  def show
    redirect_to root_path
  end

  def new
    # create new church
    if current_user.churches_id
      redirect_to edit_church_path(current_user.church)
      return
    else
      @church = Church.unscoped.new
    end
  end

  def edit
    @church = church
    # edit form for church
    # church name locked if not super admin
  end

  def create
    @church = Church.unscoped.new(church_params)
    if @church.save
      flash[:notice] = "Church saved"
      redirect_to @church
    else
      render 'new'
    end
  end

  def update
    church.attributes = church_params
    if church.save
      flash[:notice] = 'Church updated'
      redirect_to root_path()
    else
      render 'edit'
    end
  end

private

  def churches
    @churches ||= Church.all
  end

  def church
    @church ||= churches.find_by_slug(params[:id])
  end

  def church_params
    params.require(:church).permit(:church_name,
                                   :email,
                                   :url,
                                   :phone,
                                   :city,
                                   :address,
                                   :graphics_id)
  end

end
