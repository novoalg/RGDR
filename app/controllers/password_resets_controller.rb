class PasswordResetsController < ApplicationController
  before_action :get_user, only: [:edit, :update]
  before_action :valid_user, only: [:edit, :update]
  before_action :check_expiration, only: [:edit, :update]
  include SessionsHelper

  def new
  end

  def create
    @user = User.find_by(email: params[:password_reset][:email].downcase)
    if @user
        @user.create_reset_digest
        UserMailer.password_reset(@user).deliver
        flash[:info] = "Password reset link has been sent to your email inbox."
        redirect_to root_path
    else
        flash[:error] = "Email address has not been found in our records."
        render 'new'
    end
  end

  def edit
  end

  def update
    if params[:user][:password].empty? && params[:user][:password] != params[:user][:password_confirmation]
        @user.errors.add(:password, "cannot be empty")
        render 'edit'
    elsif @user.update_attributes(user_params)
        @user.update_attribute(:reset_digest, nil)
        log_in @user
        flash[:success] = "Your password has been reset."
        redirect_to root_path
    else
        render 'edit'
    end
  end

  private

    def user_params
        params.require(:user).permit(:password, :password_confirmation)
    end

    def get_user
        @user = User.find_by(email: params[:email])
    end

    def valid_user
        unless (@user && @user.email_confirmed? && @user.authenticated_reset?(params[:id]))
            redirect_to root_path
        end
    end

    def check_expiration
        if @user.password_reset_expired?
            flash[:error] = "Password reset link has expired."
            redirect_to new_password_reset_path
        end
    end
end
