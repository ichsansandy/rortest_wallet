class ApplicationController < ActionController::API
  private

  def authorize_request
    header = request.headers['Authorization']
    if header.present? && header.start_with?('Bearer ')
      token = header.split(' ').last
      begin
        decoded = JwtService.decode(token)
        @current_user = User.find(decoded[:user_id]) if decoded
      rescue ActiveRecord::RecordNotFound => e
        render json: { errors: e.message }, status: :unauthorized
      rescue JWT::DecodeError => e
        render json: { errors: 'Invalid token' }, status: :unauthorized
      end
    else
      render json: { errors: 'Incorrect token prefix' }, status: :unauthorized
    end
  end
end
