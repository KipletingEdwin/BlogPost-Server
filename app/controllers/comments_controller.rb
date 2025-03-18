class CommentsController < ApplicationController
    before_action :authorize_request
    before_action :set_comment, only: [:update, :destroy]
  
    def create
      post = Post.find(params[:post_id])
      comment = post.comments.create(user: @current_user, content: params[:content])
      if comment.save
        render json: comment, status: :created
      else
        render json: { error: comment.errors.full_messages }, status: :unprocessable_entity
      end
    end
  
    def update
      if @comment.user == @current_user
        @comment.update(content: params[:content])
        render json: @comment
      else
        render json: { error: 'Not authorized' }, status: :forbidden
      end
    end
  
    def destroy
      if @comment.user == @current_user
        @comment.destroy
        render json: { message: 'Comment deleted' }
      else
        render json: { error: 'Not authorized' }, status: :forbidden
      end
    end
  
    private
  
    def set_comment
      @comment = Comment.find(params[:id])
    end
  end
  