class Api::V1::SignupController < DeviseTokenAuth::RegistrationsController
  protect_from_forgery

  def update
    return render json: { errors: '未ログイン' }, status: 401 unless api_v1_user_signed_in?

    @user = current_api_v1_user

    if @user.update_without_password(account_update_params)
      render json: { user: @user }, status: 200
    else
      render json: { errors: @user.errors.full_messages }, status: 422
    end
  end

  def destory
    return render json: { error: '未ログイン' }, status: 401 unless api_v1_user_signed_in?

    @user = current_api_v1_user
    
    if @user.destroy
      render status: 200
    else
      render json: { errors: @user.errors.full_messages }, status: 422
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
  