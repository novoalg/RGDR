class BlogsController < ApplicationController
  include ApplicationHelper
  before_action :set_blog, only: [:show, :edit, :update, :destroy]
  before_action :has_access_admin, except: [:show, :index]
  before_action :inactive_blog_visibility, only: [:show]

  # GET /blogs
  # GET /blogs.json
  def index
    @blogs = Blog.where(active: true).order(created_at: :desc)
    logger.info "*********************************"
    logger.info @blogs.inspect
    logger.info "*********************************"
  end

  # GET /blogs/1
  # GET /blogs/1.json
  def show
    @comments = @blog.comments.order(created_at: :desc)
    logger.info "**************************"
    logger.info "COMMENTS"
    logger.info @comments.inspect
    logger.info @comments.inspect
    logger.info @comments.empty?
    logger.info @comments.any?
    logger.info @comments.blank?
    logger.info "**************************"
    @new_comment = @blog.comments.new(blog_id: @blog.id)
  end

  # GET /blogs/new
  def new
    @blog = current_user.blogs.new 
  end

  # GET /blogs/1/edit
  def edit

  end

  def toggle_active
    @blog = Blog.find_by_id(params[:id])
    if @blog.active 
        @blog.update_attribute(:active, false)
    else 
        @blog.update_attribute(:active, true)
    end
    #cheeky one line if statement
    flash[:info] = "Blog as been #{(@blog.active) ? "activated" : "deactivated"}"
    redirect_to blogs_management_path
  end

  def management
    @inactive_blogs = Blog.where(active: false).order(created_at: :desc)
    @blogs = Blog.where(active: true).order(created_at: :desc)
  end

  # POST /blogs
  # POST /blogs.json
  def create
    #create blog based on current user logged in
    @blog = current_user.blogs.new(blog_params)
    @blog.active = 1
    respond_to do |format|
      if @blog.save
        flash[:success] = "Blog was created successfully."
        format.html { redirect_to @blog }
        format.json { render :show, status: :created, location: @blog }
      else
        format.html { render :new }
        format.json { render json: @blog.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /blogs/1
  # PATCH/PUT /blogs/1.json
  def update
    respond_to do |format|
      if @blog.update(blog_params)
        flash[:success] = "Blog updated successfully."
        format.html { redirect_to @blog } 
        format.json { render :show, status: :ok, location: @blog }
      else
        format.html { render :edit }
        format.json { render json: @blog.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /blogs/1
  # DELETE /blogs/1.json
  def destroy
    respond_to do |format|
      format.html { redirect_to blogs_url, notice: 'Blog was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_blog
      @blog = Blog.find_by_id(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def blog_params
        params.require(:blog).permit(:title, :user_id, :content)
    end

    def inactive_blog_visibility
        @blog = Blog.find_by_id(params[:id])
        if @blog.active
            true
        else
            if current_user && current_user.admin?
                true
            else
                false
                flash[:info] = "You cannot see inactive posts."
                redirect_to blogs_path
            end
        end
    end
    
end
