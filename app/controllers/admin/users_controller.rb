class Admin::UsersController < ApplicationController
  
  before_filter :require_admin_user
  def index
    @unconfirmed_users = User.actors.unconfirmed.all
    @confirmed_users = User.actors.confirmed.all
  end

  def confirm
    user = User.find(params[:user_id])
    user.confirmed = true
    # todo: error handling??
    user.save
    
    redirect_to admin_users_path
  end
  
  
  def unconfirm
    user = User.find(params[:user_id])
    user.confirmed = false
    # todo: error handling??
    user.save
    
    redirect_to admin_users_path
  end

end
