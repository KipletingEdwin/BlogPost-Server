class PostsController < ApplicationController
    before_action :authorize_request, except: [:index]
    before_action :set_post, only: [:update, :destroy]
  
    def index
      posts = Post.includes(:user).all
      render json: posts, include: :user
    end
  
    def create
      post = @current_user.posts.create(post_params)
      if post.save
        render json: post, status: :created
      else
        render json: { error: post.errors.full_messages }, status: :unprocessable_entity
      end
    end
  
    def update
      if @post.user == @current_user
        @post.update(post_params)
        render json: @post
      else
        render json: { error: 'Not authorized' }, status: :forbidden
      end
    end
  
    def destroy
      if @post.user == @current_user
        @post.destroy
        render json: { message: 'Post deleted' }
      else
        render json: { error: 'Not authorized' }, status: :forbidden
      end
    end
  
    private
  
    def set_post
      @post = Post.find(params[:id])
    end
  
    def post_params
      params.permit(:title, :content, :image)
    end
  end
  