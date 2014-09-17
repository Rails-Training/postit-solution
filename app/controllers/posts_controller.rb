class PostsController < ApplicationController
 
  before_action :set_post, only: [:show, :edit, :update]
  before_action :retrieve_user, except: [:index, :show]

  def index
    @posts = Post.all
  end
  
  def show
    @comment = Comment.new
  end
  
  def new
    @post = Post.new  
  end
  
  def create
    @post = Post.new(check_params)
    @post.creator = current_user
    if @post.save
      flash[:notice] = "Post successfully saved."
      redirect_to posts_path
    else
      render :new
    end
  end
  
  def edit
  end
  
  def update
    if @post.update(check_params)
      flash[:notice] = "Post successfully updated."
      redirect_to posts_path
    else
      render :edit
    end
  end
  
  private

  def check_params
    params.require(:post).permit(:title, :url, :description, category_ids: [])
  end
 
  def set_post
    @post = Post.find(params[:id])
  end
  
end
