class Api::V1::SessionsController < DeviseTokenAuth::SessionsController
  protect_from_forgery

  wrap_parameters format: []

  def guest_sign_in
    @resource = User.guest!
    @token = @resource.create_token
    @resource.save!
    render_create_success
  end

  def check_login
    if api_v1_user_signed_in?
      render json: { user: current_api_v1_user.as_json(include: [:profile]) }, status: :ok
    else
      render json: { user: nil }, status: :ok
    end
  end
end
