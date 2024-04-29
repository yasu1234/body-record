class Api::V1::SignupController < DeviseTokenAuth::RegistrationsController
  protect_from_forgery

  def update
    if api_v1_user_signed_in?
        @user = current_api_v1_user
    else
    end
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
    if api_v1_user_signed_in?
        @user = current_api_v1_user
    else
    end
    
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
  