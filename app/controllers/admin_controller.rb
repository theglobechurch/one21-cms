class AdminController < ApplicationController

  before_action :authenticate_user!

  def index
    if current_user.church
      @church = current_user.church
      @guides = @church.guides.not_deleted
    else
      # If no church setup then redirect to set one up…
      notice = "You must create your church before proceeding"
      redirect_to new_church_url, notice: notice
    end
  end

end
