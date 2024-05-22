class Api::V1::PasswordsController < DeviseTokenAuth::PasswordsController
  before_action :check_login

  def update
    unless current_api_v1_user.update_with_password(password_edit_params)
      render json: { errors: current_api_v1_user.errors.full_messages }, status: 422 and return
    end
  
    render json: { user: current_api_v1_user }, status: 200
  end
  
  private

  def password_edit_params
    params.permit(:password, :password_confirmation, :current_password)
  end
end
