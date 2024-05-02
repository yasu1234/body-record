class Api::V1::SignupController < DeviseTokenAuth::RegistrationsController
  protect_from_forgery

  def update
    return render json: { error: '未ログイン' }, status: 401 unless api_v1_user_signed_in?

    @user = current_api_v1_user

    if sign_up_params[:email].present?
      if @user.update_without_password(sign_up_params)
        render json: { user: @user }, status: 200
      else
        render json: { errors: @user.errors }, status: 422
      end
    else
    end
  end

  def destory
    return render json: { error: '未ログイン' }, status: 401 unless api_v1_user_signed_in?

    @user = current_api_v1_user
    
    if @user.destroy
      render status: 200
    else
      render json: { errors: @user.errors }, status: 422
    end
  end

  private
  
  def sign_up_params
    params.permit(:email, :password, :password_confirmation, :name)
  end
end
  