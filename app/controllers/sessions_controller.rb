class SessionsController < ApplicationController
  include SessionsHelper

  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
        flash[:success] = "Welcome #{user.first_name} #{user.last_name}!"
        log_in user
        params[:session][:remember_me] ? remember(user) : forget(user)
        redirect_to root_path
    else
        flash.now[:error] = "Invalid email and password combination"
        render 'new'
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_path
  end

end
