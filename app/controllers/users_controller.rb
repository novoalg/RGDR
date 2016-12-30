class UsersController < ApplicationController
  include SessionsHelper
  include ApplicationHelper
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :set_user_state, only: [:edit, :update] 
  before_action :has_access, only: [:edit, :index, :show, :update, :destroy]

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
    #trim ( ) - characters from phone if entered
    p = @user.phone
    p = p.tr('()-', '') 
    @user.phone = p

    respond_to do |format|
      if @user.save
        log_in @user
        flash[:success] = "User was successfully created."
        format.html { redirect_to @user }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    #trim ( ) - characters from phone if entered
    p = @user.phone
    p = p.tr('()-', '') 
    @user.phone = p
    respond_to do |format|
      if @user.authenticate(params[:user][:password]) && @user.update(user_params) 
        flash[:success] = "User updated successfully."
        format.html { redirect_to @user } 
        format.json { render :show, status: :ok, location: @user }
      else
        flash.now[:error] = "Incorrect password."
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
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
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

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      #params.fetch(:user, {})
      params.require(:user).permit(:first_name, :last_name, :age, :email, :address_line_one, :address_line_two, :city, :password, :password_confirmation, :state, :zip, :phone)
    end
end
