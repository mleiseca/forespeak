class UsersController < ApplicationController
  
  skip_before_filter :require_user, :only => [:new, :create]
  
  
  def new
    @user = User.new
  end
  
  def index 
    @users = User.all
  end 
  
  def create
    @user = User.new(params[:user])
    @user.cash = 10000
    if @user.save
      flash[:notice] = "Registration successful."
      redirect_to root_url
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
      redirect_to root_url
    else
      render :action => 'edit'
    end
  end
  
  def resupply
    amount = params[:amount]
    if amount.match(/^\d+/)
      User.find_each do |user|
        user.cash = user.cash + amount.to_i
        user.save()
      end 
    else
      flash[:error] = "Invalid amount: #{amount}"
    end
    redirect_to users_path
  end
end
