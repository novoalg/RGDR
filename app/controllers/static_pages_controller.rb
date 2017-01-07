class StaticPagesController < ApplicationController
  include ApplicationHelper
  before_action :set_static_page, only: [:show, :edit, :update, :destroy]
  before_action :has_access_admin, except: [:home, :about_us, :woofs_for_help, :help, :contact_us]

  #Editable Pages
   
  def home
    @debug = params
    params.each do |k, v|
        puts "#{k} : #{v}"
    end
    #logger.info "Rails env: #{Rails.env}"
    #logger.info "*************"
    @homeblockone = StaticPage.first.home_block_one
  end

  def about_us
    @aboutus = StaticPage.first.about_us
  end

  def woofs_for_help
    @woofsforhelp = StaticPage.first.woofs_for_help
  end

  def help
    @help = StaticPage.first.help
  end

  def contact_us
    @help = StaticPage.first.contact_us
  end


  #Edit GET requests
  def edit_home 
    @sp = StaticPage.first
    @spname = "Home"
  end

  def edit_about_us
    @sp = StaticPage.first
    @spname = "About Us"
  end

  def edit_woofs_for_help
    @sp = StaticPage.first
    @spname = "Woofs for Help"
  end

  def edit_help
    @sp = StaticPage.first
    @spname = "Help"
  end

  def edit_contact_us
    @sp = StaticPage.first
    @spname = "Contact Us"
  end

  def edit_sidebar
    @sp = StaticPage.first
    @spname = "Sidebar"
  end


  # GET /static_pages
  def index
    @sp = StaticPage.first
  end

  # GET /static_pages/1
  # GET /static_pages/1.json
  def show
  end

  # GET /static_pages/new
  def new
    @static_page = StaticPage.new
  end

  # GET /static_pages/1/edit
  def edit
        #flash[:warning] = "This page cannot be edited or does not exist"
        #redirect_to static_pages_path
  end

  
  # POST /static_pages
  # POST /static_pages.json
  def create
    @static_page = StaticPage.new(static_page_params)

    respond_to do |format|
      if @static_page.save
        format.html { redirect_to @static_page }
        format.json { render :show, status: :created, location: @static_page }
      else
        format.html { render :new }
        format.json { render json: @static_page.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /static_pages/1
  # PATCH/PUT /static_pages/1.json
  def update
    @sp = @static_page
    respond_to do |format|
      if @static_page.update(static_page_params)
        flash[:success] = "Page updated successfully."
        format.html { redirect_to static_pages_path }
        format.json { render :show, status: :ok, location: static_pages_path }
      else
        flash[:error] = "Page cannot be blank."
        format.html { redirect_to static_pages_path }
      end
    end
  end

  # DELETE /static_pages/1
  # DELETE /static_pages/1.json
  def destroy
    respond_to do |format|
      format.html { redirect_to root_path } 
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_static_page
      @static_page = StaticPage.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def static_page_params
      params.fetch(:static_page, {})
      params.require(:static_page).permit(:about_us, :contact_us, :help, :sidebar, :home_block_one, :woofs_for_help)
    end


end
