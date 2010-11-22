class UsersController < ApplicationController
  def new
    @user = User.new
  end
  
  def index 
    @users = User.all
  end 
  
  def create
    @user = User.new(params[:user])
    if @user.save
      flash[:notice] = "Registration successful."
      redirect_to users_path
    else
      render :action => 'new'
    end
  end
  
  def edit
    @user = current_user
  end
  
  def show
    @user = User.find(params[:id])
  end
  
  def update
    @user = current_user
    if @user.update_attributes(params[:user])
      flash[:notice] = "Successfully updated user."
      redirect_to users_path
    else
      render :action => 'edit'
    end
  end
end
