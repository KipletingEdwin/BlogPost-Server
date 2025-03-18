class UsersController < ApplicationController
    require 'jwt'
  
    def signup
      user = User.new(user_params)
      if user.save
        token = encode_token(user.id)
        render json: { user: user, token: token }, status: :created
      else
        render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
      end
    end
  
    def login
      user = User.find_by(username: params[:username])
      if user && user.authenticate(params[:password])
        token = encode_token(user.id)
        render json: { user: user, token: token }, status: :ok
      else
        render json: { error: 'Invalid credentials' }, status: :unauthorized
      end
    end
  
    private
  
    def encode_token(user_id)
      JWT.encode({ user_id: user_id }, Rails.application.secrets.secret_key_base, 'HS256')
    end
  
    def user_params
      params.permit(:username, :password, :password_confirmation)
    end
  end
  