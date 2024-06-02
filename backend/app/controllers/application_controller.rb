class ApplicationController < ActionController::Base
  include DeviseTokenAuth::Concerns::SetUserByToken

  protect_from_forgery unless: -> { request.format.json? }

  def check_login
    render json: { errors: "未ログイン" }, status: :unauthorized unless api_v1_user_signed_in?
  end
end
