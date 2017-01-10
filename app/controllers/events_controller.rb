class EventsController < ApplicationController
  include ApplicationHelper
  before_action :set_event, only: [:show, :edit, :update, :destroy]
  before_action :has_access_admin, only: [:edit, :new, :create, :update, :destroy]

  # GET /events
  # GET /events.json
  def index
    @event_block = StaticPage.first.event
    @events = Event.where(special: false).order(created_at: :asc)
  end

  def special_events
    @event_block = StaticPage.first.special_event
    @events = Event.where(special: true).order(created_at: :asc)
  end

  # GET /events/1
  # GET /events/1.json
  def show
  end

  # GET /events/new
  def new
    @event = Event.new
  end

  # GET /events/1/edit
  def edit
  end

  # POST /events
  # POST /events.json
  def create
    @event = Event.new(event_params)
    respond_to do |format|
      if @event.save
        flash[:success] = "Event #{@event.name} was created successfully."
        format.html { redirect_to events_path }
        format.json { render :show, status: :created, location: @event }
      else
        format.html { render :new }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /events/1
  # PATCH/PUT /events/1.json
  def update
    respond_to do |format|
      if @event.update(event_params)
        flash[:success] = "Event updated successfully."
        format.html { redirect_to @event }
        format.json { render :show, status: :ok, location: @event }
      else
        format.html { render :edit }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /events/1
  # DELETE /events/1.json
  def destroy
    respond_to do |format|
      format.html { redirect_to events_url, notice: 'Event was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_event
      @event = Event.find_by_id(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def event_params
      #params.fetch(:event, {})
      params.require(:event).permit(:name, :location, :time, :date, :special, :information)
    end
    
end
