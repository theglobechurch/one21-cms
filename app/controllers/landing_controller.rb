class LandingController < ApplicationController
  before_action :login_check

  helper_method :resource_name, :resource, :devise_mapping

  def index; end

  def resource_name
    :user
  end

  def resource
    @resource ||= User.new
  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end

private

  def login_check
    redirect_to admin_index_path if user_signed_in?
  end

end
