class UsersController < ApplicationController
  include SessionsHelper
  include ApplicationHelper
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :set_user_state, only: [:edit, :update] 
  before_action :same_user, only: [:edit, :show, :update]
  before_action :no_admin_prevention, only: [:hierarchy, :set_hierarchy]
  before_action :has_access, only: [:edit, :show, :update]
  before_action :has_access_admin, only: [:hierarchy, :set_hierarchy, :destroy]
  before_action :has_access_moderator, only: [:index]

  # GET /users
  # GET /users.json
  def index
    @users = User.all
  end

  # GET /users/1
  # GET /users/1.json
  def show
  end

  # GET /users/new
  def new
    @user = User.new
    states = CS.states(:us)
    logger.info states.inspect
    @states = []
    @cities = CS.cities(:ak, :us)
    states.each do |k, v|
        @states.push k
    end
  end

  def set_state
    state = params[:selected_state]
    @cities = CS.cities(state, :us)
    logger.info @cities.inspect
    respond_to do |format|
        format.json { render json: @cities }
    end
  end   

  # GET /users/1/edit
  def edit
    @user = User.find_by_id(params[:id])
  end

  def hierarchy 
    @user = User.find_by_id(params[:id])
  end

  def set_hierarchy 
    @user = User.find_by_id(params[:id])
    case params[:user_h]
        when "admin"
            logger.info "hierarchy = 0"
            hierarchy = 0
        when "moderator"
            logger.info "hierarchy = 1"
            hierarchy = 1
        when "member"
            logger.info "hierarchy = 2"
            hierarchy = 2
        else
            flash[:error] = "Hiearchy format not allowed."
            redirect_to "/user/#{@user.id}/user_management"
    end

    if @user.update_attribute(:hierarchy, hierarchy)
        flash[:success] = "#{@user.full_name} power was set to: #{params[:user_h]}"
        redirect_to @user
    else
        if @user.errors.empty?
            flash[:info] = "User is already at this hierarchy"
            redirect_to "/user/#{@user.id}/user_management"
        else
            respond_to do |format|
                format.html { render :hierarchy }
                format.json { render json: @user.errors, status: :unprocessable_entity }
            end
        end
    end
    
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)

    #Set state/cities variables
    states = CS.states(:us)
    state = user_params[:state]
    @states = []
    states.each do |k, v|
        @states.push k
    end

    @cities = CS.cities(state, :us)
    p = @user.phone
    #trim unwanted values
    p = p.tr('()-', '') 
    #trim whitespace
    p = p.tr(' ', '')
    @user.phone = p
    #0 = admin; 1 = moderator; 2 = member
    #default: 2
    @user.hierarchy = 2
    if user_params[:subscribed] && user_params[:subscribe] == 'true'
        @user.subscribed = true
    else
        @user.subscribed = false
    end
    #user must confirm email before login in
    @user.email_confirmed = 0
    respond_to do |format|
      if @user.save
        UserMailer.welcome_email(@user).deliver
        flash[:success] = "Your account was created successfully! Please confirm your email address to login."
        format.html { redirect_to login_path }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def confirm_email
    logger.info "*****************************"
    logger.info "IN CONFIRM_EMAIL"
    logger.info params.inspect
    logger.info "*****************************"
  end
  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    #trim ()- characters from phone if entered
    p = @user.phone
    digits_p = p.tr('()-', '') 
    trimmed_p = digits_p.tr(' ', '')
    params[:user][:phone] = trimmed_p
    respond_to do |format|
      if @user.authenticate(params[:user][:password]) && @user.update(user_params) 
        flash[:success] = "User updated successfully."
        format.html { redirect_to @user } 
        format.json { render :show, status: :ok, location: @user }
      elsif @user.errors.empty?
        flash.now[:error] = "Incorrect password."
        format.html { render :edit }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    respond_to do |format|
      flash[:info] = "User deactivated"
      format.html { redirect_to users_url } 
      format.json { head :no_content }
    end
  end

  private
    def set_user
      @user = User.find_by_id(params[:id])
      if !@user
          redirect_to root_path
          flash[:error] = "We could not find that user."
      end
    end

    def set_user_state
        @user = User.find(params[:id])
        states = CS.states(:us)
        @states = []
        @cities = CS.cities(@user.state, :us)
        states.each do |k, v|
            @states.push k
        end
    end

    def no_admin_prevention
        if current_user
            if (current_user.id == params[:id].to_i)
                flash[:info] = "You cannot change your own hierarchy."
                redirect_to users_path
            else
                true
            end
        end

    end
    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      #params.fetch(:user, {})
      params.require(:user).permit(:first_name, :last_name, :age, :email, :address_line_one, :address_line_two, :city, :password, :password_confirmation, :state, :zip, :phone)
    end
end
