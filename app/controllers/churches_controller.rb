class ChurchesController < ApplicationController

  before_action :authenticate_user!

  def index
    # if super admin list all the church
    if current_user.superadmin?
      @churches = churches

    # If has a church there is no need to be here
    elsif current_user.churches_id
      redirect_to root_path

    # Argh, no church; go and create one
    else
      redirect_to new_church_url
    end
  end

  def show
    redirect_to root_path
  end

  def new
    if current_user.churches_id
      redirect_to edit_church_path(current_user.church)
    else
      @church = Church.unscoped.new
    end
  end

  def edit
    @church = church
    # TODO: church name locked if not super admin
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
      redirect_to root_path
    else
      render 'edit'
    end
  end

private

  def churches
    @churches ||= Church.all
  end

  def church
    @church ||= churches.find_by!(slug: params[:id])
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
