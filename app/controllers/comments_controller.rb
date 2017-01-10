class CommentsController < ApplicationController
  include ApplicationHelper
  before_action :set_comment, only: [:show, :edit, :update, :destroy]
  before_action :has_access, only: [:new, :edit, :update, :create, :destroy]
  before_action :same_user, only: [:edit, :update, :destroy ]

  # GET /comments
  # GET /comments.json
  def index
    @comments = Comment.all
  end

  # GET /comments/1
  # GET /comments/1.json
  def show
  end

  # GET /comments/new
  def new
    @comment = Comment.new
  end

  # GET /comments/1/edit
  def edit
    @edit_comment = Comment.find_by_id(params["edit_comment_id"])
    respond_to do |format|
        if same_user
            format.html { render partial: "edit_form", success: true, locals: { :edit_comment => @edit_comment } }
            format.json { render @blog }
        else
            flash[:error] = "You don't have permission to to that."
            format.html { redirect_to @blog, success: false}
        end
    end
  end

  # POST /comments
  # POST /comments.json
  def create
    @blog = Blog.find_by_id(params[:blog_id])
    @comment = @blog.comments.new(comment_params)
    @comment.user_id = current_user.id
    respond_to do |format|
      if @comment.save
        flash[:success] = "Thank you for your input!"
        format.html { redirect_to @blog } 
        format.json { render "/blogs/#{@blog.id}" }
      else
        format.html { redirect_to @blog}
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /comments/1
  # PATCH/PUT /comments/1.json
  def update
    respond_to do |format|
    @blog = @comment.blog
      if @comment.update(comment_params)
        flash[:success] = "Comment was updated."
        format.html { redirect_to @comment.blog }
      else
        flash[:error] = "Your comment cannot be empty."
        format.html { redirect_to @blog }
      end
    end
  end

  # DELETE /comments/1
  # DELETE /comments/1.json
  def destroy
    respond_to do |format|
      format.html { redirect_to comments_url, notice: 'Comment was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_comment
      @comment = Comment.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def comment_params
      #params.fetch(:comment, {})
      params.require(:comment).permit(:content, :user_id, :blog_id)
    end
end
