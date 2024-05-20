class Api::V1::SignupController < DeviseTokenAuth::RegistrationsController
  protect_from_forgery

  before_action :check_login, only: %i[update destory]

  def update
    if current_api_v1_user.update_without_password(account_update_params)
      render json: { user: current_api_v1_user }, status: 200
    else
      render json: { errors: current_api_v1_user.errors.full_messages }, status: 422
    end
  end

  def destory
    return render json: { error: '未ログイン' }, status: 401 unless api_v1_user_signed_in?
    
    if current_api_v1_user.destroy
      render status: 200
    else
      render json: { errors: current_api_v1_user.errors.full_messages }, status: 422
    end
  end

  private
  
  def sign_up_params
    params.permit(:email, :password, :password_confirmation, :name)
  end

  def account_update_params
    params.permit(:email, :password, :password_confirmation, :name, :image)
  end
end
  