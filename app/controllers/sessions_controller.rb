class SessionsController < ApplicationController
  
  before_action
  
  def new
  end
  
  def create
    user = User.find_by(username: params[:username])
    if user && user.authenticate(params[:password])
      if user.two_factor_auth?
        session[:two_factor] = true 
        user.generate_pin!
        user.send_pin_to_twilio
        redirect_to pin_path
      else
        login_user! user        
      end
    else
      flash[:error] = "Invalid username or password"
      redirect_to login_path
    end 
  end
  
  def destroy
    session[:user_id] = nil
    flash[:notice] = "Successfully logged out"
    redirect_to root_path
  end
  
  def pin
    access_denied if session[:two_factor].nil?
    if request.post?
      user = User.find_by pin: params[:pin]
      if user
        user.remove_pin!
        login_user! user
      else
        flash[:error] = 'Authentication failed'
        redirect_to pin_path
      end 
    end
  end
  
  private
  
  def login_user!(user)
    session[:two_factor] = nil
    session[:user_id] = user.id
    flash[:notice] = "Login successful"
    redirect_to root_path
  end 
  
  
end