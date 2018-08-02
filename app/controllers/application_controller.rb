class ApplicationController < ActionController::Base

  before_action :set_current_user

private

  def set_current_user
    User.current = current_user if current_user
  end

  def check_church_owner(church_slug)
    if current_user && current_user.church.slug != church_slug
      flash[:notice] = "You are not authorized to be go there"
      redirect_to admin_index_path
    end
  end

end
