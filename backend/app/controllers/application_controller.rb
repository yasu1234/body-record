class ApplicationController < ActionController::Base
  include DeviseTokenAuth::Concerns::SetUserByToken

  before_action :check_xhr_header

  protect_from_forgery with: :null_session

  rescue_from StandardError, with: :rescue_500

  def check_login
    render json: { errors: "未ログイン" }, status: :unauthorized unless api_v1_user_signed_in?
  end

  private

  # 固有のヘッダが指定されている場合のみ許可(CSRF対策)
    def check_xhr_header
      return if request.xhr?

      render json: { errors: "forbidden" }, status: :forbidden
    end

    def rescue_500(e)
      render json: { errors: e.message }, status: :internal_server_error
    end
end
