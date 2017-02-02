class BlogsController < ApplicationController
  include ApplicationHelper
  before_action :set_blog, only: [:show, :edit, :update, :destroy]
#Moderators should have acces to blog functionality
  before_action :has_access_moderator, except: [:show, :index]
  before_action :inactive_blog_visibility, only: [:show]
#Lisa wanted to change the name from blog to news so it's a mess with the naming convention

  # GET /blogs
  # GET /blogs.json
  def index
    @blogs = Blog.where(active: true).order(created_at: :desc)
  end

  # GET /blogs/1
  # GET /blogs/1.json
  def show
    @comments = @blog.comments.order(created_at: :desc)
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
    flash[:info] = "Article as been #{(@blog.active) ? "activated" : "deactivated"}."
    redirect_to news_management_path
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
    if params[:blog][:active] && params[:blog][:active] == 'true'
        @blog.active = true
    else
        @blog.active = false
    end
    respond_to do |format|
      if @blog.save
        flash[:success] = "Article was created successfully."
# send email after article posted ONLY IF ACTIVE
        if @blog.active
            users = User.where(subscribed: true)
            UserMailer.news_email(users, @blog).deliver
        end
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
        flash[:success] = "Article updated successfully."
        format.html { redirect_to new_path(@blog) } 
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
      format.html { redirect_to blogs_url }
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
