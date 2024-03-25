class Api::V1::SignupController < DeviseTokenAuth::RegistrationsController
  protect_from_forgery

  private
  
  def sign_up_params
    params.permit(:email, :password, :password_confirmation, :name)
  end
end
  