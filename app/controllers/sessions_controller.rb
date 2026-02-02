class SessionsController < ApplicationController
  def new
    redirect_to admin_dashboard_path if current_user&.admin?
    redirect_to distributors_dashboard_path if current_user&.distributor?
  end

  def create
    user = User.find_by(email: params[:email])

    if user&.authenticate(params[:password])
      session[:user_id] = user.id
      flash[:notice] = "Logged in successfully!"
      
      if user.admin?
        redirect_to admin_dashboard_path
      else
        redirect_to distributors_dashboard_path
      end
    else
      flash.now[:alert] = "Invalid email or password"
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    session[:user_id] = nil
    flash[:notice] = "Logged out successfully!"
    redirect_to login_path
  end
end
