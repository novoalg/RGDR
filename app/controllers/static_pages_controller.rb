class StaticPagesController < ApplicationController
  include ApplicationHelper
  require 'will_paginate/array'
  before_action :set_sp
  before_action :set_static_page, only: [:show, :edit, :update, :destroy]
  before_action :has_access_admin, except: [:home, :about_us, :woofs_for_help, :foster, :donate, :adopt, :event, :special_event, :help, :contact_us]

  #Editable Pages
   
  def home
    @debug = params
    params.each do |k, v|
        puts "#{k} : #{v}"
    end
    @homeblockone = StaticPage.first.home_block_one
#parse XML
    url = "http://api.adoptapet.com/search/pets_at_shelter?key=56f8d6ec5a75c3a28c5893fad35d250f&shelter_id=82425"
    uri = URI(url)
    response = Net::HTTP.get(uri)
    @hash = Hash.from_xml(response) 
    @order= @hash["result"]["pets"]
    @details_hash = {}
    @pets = @order.sort_by { |k| k["pet_name"] }
    @pets.each_with_index do |pet, i|
#url format http://www.adoptapet.com/pet/PET_ID-PET_CITY-PET_STATE-PET_PRIMARY_BREED-MIX
#apparently only the ID makes the URL work. so we're just gonna do that
#MIX is included if it has a secondary breed
#state has to be uppercase converted to symbol to look for full state name using CS gem
        #state = pet["addr_state_code"].parameterize.upcase.to_sym
        #breed = pet["primary_breed"]
#make breed lower case
        #trimmed_breed = breed.downcase.gsub(/^[^a-z0-9\s]/i, '')
        #trimmed_breed = trimmed_breed.tr(' ', '-')
        #@pet_url = "http://www.adoptapet.com/pet/"+pet["pet_id"]+"-"+pet["addr_city"].downcase+"-"+CS.states(:us)[state].downcase+"-"+trimmed_breed
        #@pet_url += "-mix"


        @pet_url = "http://www.adoptapet.com/pet/"+pet["pet_id"]
        @details_hash["#{i}"] = @pet_url
    end
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
    @contactus = StaticPage.first.contact_us
  end

  def foster
    @foster = StaticPage.first.foster
  end

  def donate
    @donate = StaticPage.first.donate
  end

  #Edit GET requests
  def edit_home 
    @spname = "Home"
  end

  def edit_about_us
    @spname = "About Us"
  end

  def edit_woofs_for_help
    @spname = "Woofs for Help"
  end

  def edit_help
    @spname = "Help"
  end

  def edit_contact_us
    @spname = "Contact Us"
  end

  def edit_sidebar
    @spname = "Sidebar"
  end

  def edit_donate
    @spname = "Donate"
  end

  def edit_event
    @spname = "Event"
  end

  def edit_special_event
    @spname = "Special Event"
  end

  def edit_foster
    @spname = "Foster"
  end

  def edit_adopt
    @spname = "Adopt"
  end

  # GET /static_pages
  def index
    @sp = StaticPage.first
  end

  # GET /static_pages/new
  def new
    @static_page = StaticPage.new
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
    
    def set_sp
      @sp = StaticPage.first
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def static_page_params
      params.fetch(:static_page, {})
      params.require(:static_page).permit(:about_us, :contact_us, :help, :sidebar, :home_block_one, :woofs_for_help, :event, :special_event, :foster, :donate, :adopt)
    end


end
