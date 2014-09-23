class CommentsController < ApplicationController
  
  before_action :set_post
  before_action :require_user
  
  def create
    binding.pry
    @comment = @post.comments.build(check_params)
    @comment.creator = current_user
    if @comment.save
      flash[:notice] = "Comments added"
      redirect_to post_path(@post)
    else
      render 'posts/show'
    end
  end
  
  def vote
    @comment = @post.comments.find(params[:id])
    @vote = Vote.create(voteable: @comment, creator: current_user, vote: params[:vote])
      respond_to do |format|
        format.html do 
          if @vote.valid?
            flash[:notice] = 'Thanks for your vote'
          else
            flash[:error] = "You can vote on #{@post.title} only once"
          end
          redirect_to :back
        end        
        format.js
      end
  end
  
  private
  
  def check_params
    params.require(:comment).permit(:body)
  end
  
  def set_post
    @post = Post.find_by(slug: params[:post_id])
  end
  
end