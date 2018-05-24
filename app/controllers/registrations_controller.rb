class RegistrationsController < Devise::RegistrationsController

protected

  # Redirect after signup…
  def after_sign_up_path_for(resource)
    # Redirect new users to create a church
    churches_path
  end

private

  def sign_up_params
    params.require(:user).permit(:first_name, :family_name, :email, :password, :password_confirmation)
  end

  def account_update_params
    params.require(:user).permit(:first_name, :family_name, :email, :password, :password_confirmation, :current_password)
  end

end
