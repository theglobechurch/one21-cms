class AdminController < ApplicationController

  before_action :authenticate_user!

  def index
    # If no church setup then redirect to set one up…
    if !current_user.church
      redirect_to new_church_url, notice: "You must create your church before proceeding"
    end

    @church = current_user.church
    @guides = @church.guides
  end

end
