class UsersController < ApplicationController
 
  before_action :set_user, only: [:show, :edit, :update]
  before_action :require_same_user, only: [:edit, :update]
  
  def show
  end  
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(check_params)
    if @user.save
      flash[:notice] = 'Registration successful'
      session[:user_id] = @user.id
      redirect_to root_path
    else
      render :new
    end      
  end
  
  def edit
  end
  
  def update
    if @user.update(check_params)
      flash[:notice] = 'Successfully updated'
      redirect_to user_path(@user)
    else
      render :edit
    end
  end
  
  private
  
  def check_params
    params.require(:user).permit(:username, :password, :phone, :time_zone)
  end
  
  def set_user
    @user = User.find_by(slug: params[:id])
  end
  
  def require_same_user
    if current_user != @user
      flash[:error] = 'Not allowed'
      redirect_to root_path
    end
  end
  
end
