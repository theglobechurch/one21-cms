class ChurchesController < ApplicationController

  before_action :authenticate_user!

  def index
    # if super admin list all the church
    if current_user.superadmin?
      @churches = churches

    # If has a church there is no need to be here
    elsif current_user.churches_id
      redirect_to admin_index_path

    # Argh, no church; go and create one
    else
      redirect_to new_church_url
    end
  end

  def show
    redirect_to admin_index_path
  end

  def new
    if !current_user.superadmin? && current_user.churches_id
      redirect_to edit_church_path(current_user.church)
    else
      @church = Church.unscoped.new
    end
  end

  def edit
    check_church_owner(params[:id])

    @church = church
    # TODO: church name locked if not super admin
  end

  def create
    @church = Church.unscoped.new(church_params)
    if @church.save
      flash[:notice] = "Church created"
      redirect_to admin_index_path
    else
      render 'new'
    end
  end

  def update
    @church = church
    @church.attributes = church_params
    if @church.save
      flash[:notice] = 'Church updated'
      redirect_to admin_index_path
    else
      render 'edit'
    end
  end

private

  def churches
    @churches ||= Church.all
  end

  def church
    @church ||= churches.find_by(slug: params[:id])
  end

  def church_params
    pa = params.require(:church).permit(:church_name,
                                        :email,
                                        :url,
                                        :phone,
                                        :city,
                                        :address,
                                        :graphics_id,
                                        :church_logo,
                                        :church_logo_sq)

    if (church && !church.church_logo_sq) && !pa[:church_logo_sq]
      pa[:church_logo_sq] = pa[:church_logo]
    end

    pa
  end

end
