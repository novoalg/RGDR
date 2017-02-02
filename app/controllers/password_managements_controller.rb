class PasswordManagementsController < ApplicationController
  include ApplicationHelper
  include SessionsHelper
  before_action :same_user
  before_action :has_access

  def edit
   @user = current_user 
  end

  def update
    @user = current_user
    if (params[:user][:current_password].empty?) || (params[:user][:password].empty?) || (params[:user][:password].length < 6) ||(params[:user][:password] != params[:user][:password_confirmation])
        @user.errors.add(:form, "cannot have an empty new password, and has to have matching new passwords with minimum length of 6 digits")
        render 'edit'
    elsif @user.authenticate(params[:user][:current_password]) && @user.update_attributes(user_params)
        flash[:success] = "Your password has been updated successfully."
        redirect_to root_path
    else
        flash[:error] = "Incorrect password."
        render 'edit'
    end
  end

  private
    def user_params
        params.require(:user).permit(:current_password, :password, :password_confiramtion)
    end
end
