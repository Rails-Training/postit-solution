class PostsController < ApplicationController
 
  before_action :set_post, only: [:show, :edit, :update, :vote]
  before_action :require_user, except: [:index, :show]
  before_action :require_creator, only: [:edit, :update]

  def index
    @posts = Post.all.sort_by{|x| x.total_votes}.reverse
    respond_to do |format|
      format.html
      format.json {render json: @posts}
      format.xml {render xml: @posts}
    end
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
  
  def vote
    @vote = Vote.create(voteable: @post, creator: current_user, vote: params[:vote])
    if @vote.valid?
      # uncomment for ajax
      #respond_to do |format|
        #format.html { redirect_to :back, notice: 'Thanks for your vote' }
        #format.js
      #end
      flash[:notice] = 'Thanks for your vote'
    else
      # uncomment for ajax
      #respond_to do |format|
        #format.html { redirect_to :back, error: "You can vote for #{@post.title} only once" }
        #format.js
      #end
      flash[:error] = 'Already voted' # comment for ajax
    end
    redirect_to :back # comment for ajax
  end
  
  private

  def check_params
    params.require(:post).permit(:title, :url, :description, category_ids: [])
  end
 
  def set_post
    @post = Post.find_by(slug: params[:id])
  end
  
  def require_creator
    access_denied unless current_user.admin? or current_user == @post.creator
  end
  
end
