class UsersController < ApplicationController
  
  before_action :authenticate_user!
  before_action :check_church_admin
  before_action :set_church

  def index
    check_super_admin
    @churches = churches
  end

  def new
    @user = User.new
  end

  def create
    u = User.find_by(email: user_params['email'])
    if !u
      u = User.new(user_params)
      u.churches_id = @church.id
    
      if u.invite!
        redirect_to admin_index_path, notice: "#{u.full_name} created" and return
      else
        redirect_to admin_index_path, alert: 'Failed saving!' and return
      end
    else
      redirect_to edit_user_path(u), alert: 'User already exists' and return
    end
  end

  def edit
    @user = user

    if !@user
      redirect_to admin_index_path, alert: 'No such user.' and return
    end

    if @user.churches_id != @church.id && current_user.role != 'superadmin'
      redirect_to admin_index_path, alert: 'That is not the user you were looking for.' and return
    end
    
    if @user == current_user
      redirect_to edit_user_registration_path
    end
  end

  def update
    user.attributes = user_params
    if user.save
      redirect_to users_path, notice: "#{user.first_name} updated" and return
    end
  end

  def destroy
    @user = user
    if @user.delete
      redirect_to admin_index_path, notice: "#{@user.first_name} removed" and return
    end
  end

private

  def set_church
    @church = current_user.church
  end

  def church_users
    @church_users ||= @church.users
    #@church_users ||= User.all
  end

  def churches
    @churches ||= Church.all
  end

  def users
    @users ||= User.all
  end

  def user
    @user ||= users.find_by(id: params[:id])
  end

  def check_church_admin
    if (!['churchadmin', 'superadmin'].include? current_user.role)
      redirect_to admin_index_path, alert: "You are not authorized to be go there"
    end
  end

  def check_super_admin
    if (!['superadmin'].include? current_user.role)
      redirect_to admin_index_path
    end
  end

  def user_params
    params.require(:user).permit(:first_name,
                                 :family_name,
                                 :email,
                                 :role)
  end

end
