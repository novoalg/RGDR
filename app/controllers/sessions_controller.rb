class SessionsController < ApplicationController
  include SessionsHelper

  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
        if user.email_confirmed
            flash[:success] = "Welcome #{user.full_name}."
            log_in user
            params[:session][:remember_me] ? remember(user) : forget(user)
            redirect_to root_path
        else
            flash[:warning] = "Please verify your email before logging in."
            render 'new'
        end
    else
        flash.now[:error] = "Invalid email and password combination"
        render 'new'
    end
  end


  def confirm_email_login
    logger.info "*****************************"
    logger.info "IN CONFIRM_EMAIL LOGIN"
    logger.info params.inspect
    logger.info "*****************************"
    user = User.find_by(email: params[:session][:email].downcase)
    if user.confirmed?
        flash[:info] = "Your email is already confirmed."
        redirect_to root_path
    else
        if user && user.authenticate(params[:session][:password])
            if user.confirm(user, params[:session][:confirm_token])
                logger.info "IN USER CONFIRMATION"
                flash[:success] = "Your email has been confirmed #{user.full_name}."
                log_in user
                params[:session][:remember_me] ? remember(user) : forget(user)
                redirect_to root_path
            end
        else
            logger.info "IN ERROR CONFIRM EMAIL LOGIN"
            redirect_to controller: "users", action: "confirm_email", confirm_token: params[:session][:confirm_token]
            flash[:error] = "Invalid email and password combination"
#'/users/confirm_email', confirm_token: params[:confirm_token]
        end

      end
    end


  def destroy
    if logged_in?
        flash[:info] = "You have logged out! Have a good day #{current_user.full_name}!"
        log_out  
    end
    redirect_to root_path
  end

end
