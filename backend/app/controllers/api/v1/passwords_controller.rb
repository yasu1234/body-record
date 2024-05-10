class Api::V1::PasswordsController < DeviseTokenAuth::PasswordsController
  before_action :set_user

  def update    
    if @user.update_with_password(password_edit_params)
      render json: { user: @user }, status: 200
    else
      render json: { errors: @user.errors.full_messages }, status: 422
    end
  end
  
  private

  def set_user
    if api_v1_user_signed_in?
      @user = current_api_v1_user
    else
      render json: { errors: "未ログイン" }, status: 401
    end
  end

  def password_edit_params
    params.permit(:password, :password_confirmation, :current_password)
  end
end
