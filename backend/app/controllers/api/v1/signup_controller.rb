class Api::V1::SignupController < DeviseTokenAuth::RegistrationsController
  protect_from_forgery

  before_action :check_login, only: %i[update destory]

  def update
    unless current_api_v1_user.update_without_password(account_update_params)
      render json: { errors: current_api_v1_user.errors.full_messages }, status: :unprocessable_entity
    end

    render json: { user: current_api_v1_user }, status: :ok
  rescue StandardError => e
    render json: { errors: e.message }, status: :internal_server_error
  end

  def destory
    current_api_v1_user.destroy!
    render json: { user: nil }, status: :ok
  rescue ActiveRecord::RecordNotFound
    render json: { errors: "対象のデータが見つかりません" }, status: :not_found
  rescue StandardError => e
    render json: { errors: e.message }, status: :internal_server_error
  end

  private

    def sign_up_params
      params.permit(:email, :password, :password_confirmation, :name)
    end

    def account_update_params
      params.permit(:email, :password, :password_confirmation, :name, :image)
    end
end
