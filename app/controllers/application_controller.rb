class ApplicationController < ActionController::API
    before_action :authorize_request
  
    private
  
    def authorize_request
      header = request.headers['Authorization']
      token = header.split(' ').last if header
      begin
        decoded = JWT.decode(token, Rails.application.secrets.secret_key_base, true, algorithm: 'HS256')
        @current_user = User.find(decoded[0]['user_id'])
      rescue ActiveRecord::RecordNotFound, JWT::DecodeError
        render json: { error: 'Invalid token' }, status: :unauthorized
      end
    end
  end
  