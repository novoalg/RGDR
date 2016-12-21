class StaticPagesController < ApplicationController
  before_action :set_static_page, only: [:show, :edit, :update, :destroy]
  before_action :set_sidebar

  #Editable Pages
  
  def home
    @debug = params
    @title = "Real Good Dog Rescue"
    logger.info "*************"
    params.each do |k, v|
        puts "#{k} : #{v}"
    end
    logger.info "Rails env: #{Rails.env}"
    logger.info "*************"
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

  # GET /static_pages
  # GET /static_pages.json
  def index
    @static_pages = StaticPage.all
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
  end

  
  # POST /static_pages
  # POST /static_pages.json
  def create
    @static_page = StaticPage.new(static_page_params)

    respond_to do |format|
      if @static_page.save
        format.html { redirect_to @static_page, notice: 'Static page was successfully created.' }
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
    respond_to do |format|
      if @static_page.update(static_page_params)
        format.html { redirect_to @static_page, notice: 'Static page was successfully updated.' }
        format.json { render :show, status: :ok, location: @static_page }
      else
        format.html { render :edit }
        format.json { render json: @static_page.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /static_pages/1
  # DELETE /static_pages/1.json
  def destroy
    @static_page.destroy
    respond_to do |format|
      format.html { redirect_to static_pages_url, notice: 'Static page was successfully destroyed.' }
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
    end

    def set_sidebar
      @sidebar = StaticPage.first.sidebar
    end
end
