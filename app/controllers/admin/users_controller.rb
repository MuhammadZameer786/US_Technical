module Admin
  class UsersController < ApplicationController
    before_action :require_admin
    before_action :set_user, only: [:show, :edit, :update, :destroy]

    def index
      @users = User.includes(:distributor).all.order(:email)
    end

    def show
    end

    def new
      @user = User.new
      @distributors = Distributor.all.order(:name)
    end

    def create
      @user = User.new(user_params)

      if @user.save
        flash[:notice] = "User created successfully."
        redirect_to admin_users_path
      else
        @distributors = Distributor.all.order(:name)
        flash.now[:alert] = "Failed to create user."
        render :new, status: :unprocessable_entity
      end
    end

    def edit
      @distributors = Distributor.all.order(:name)
    end

    def update
      if @user.update(user_params)
        flash[:notice] = "User updated successfully."
        redirect_to admin_users_path
      else
        @distributors = Distributor.all.order(:name)
        flash.now[:alert] = "Failed to update user."
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      if @user == current_user
        flash[:alert] = "You cannot delete your own account."
        redirect_to admin_users_path
      else
        @user.destroy
        flash[:notice] = "User deleted successfully."
        redirect_to admin_users_path
      end
    end

    private

    def set_user
      @user = User.find(params[:id])
    end

    def user_params
      params.require(:user).permit(:email, :password, :password_confirmation, :user_type, :distributor_id)
    end
  end
end
