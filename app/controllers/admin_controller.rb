class AdminController < ApplicationController

  before_action :authenticate_user!

  def index
    if current_user.churches_id
      @user = current_user
      @church = church
      @guides = @church.guides.not_deleted
    else
      # If no church setup then redirect to set one up…
      notice = "You must create your church before proceeding"
      redirect_to new_church_url, notice: notice
    end
  end

private

  def church
    @church ||= Church.find(current_user.churches_id)
  end

  def guides
    @guides ||= Guide.
                not_deleted.
                includes(:churches).
                where(churches: {id: @church.id})
  end

end
