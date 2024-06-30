class Api::V1::SignupController < DeviseTokenAuth::RegistrationsController
  protect_from_forgery

  before_action :check_login, only: %i[update destroy]

  def update
    if current_api_v1_user.status == User::Status::GUEST_USER &&
       (account_update_params[:email].present? || account_update_params[:password].present?)
      render json: { errors: "ゲストユーザーは変更できません" }, status: :unprocessable_entity and return
    end

    unless current_api_v1_user.update_without_password(account_update_params)
      render json: { errors: current_api_v1_user.errors.full_messages }, status: :unprocessable_entity
    end

    if account_update_params[:image].present?
      processed_image = ImageProcessing::MiniMagick
        .source(account_update_params[:image])
        .resize_to_limit(100, 100)
        .call
  
      account_update_params[:image] = processed_image
    end

    render json: { user: current_api_v1_user }, status: :ok
  end

  def destroy
    if current_api_v1_user.status == User::Status::GUEST_USER
      render json: { errors: "ゲストユーザーは退会できません" }, status: :unprocessable_entity and return
    end

    current_api_v1_user.destroy!
    render json: { user: nil }, status: :ok
  rescue ActiveRecord::RecordNotFound
    render json: { errors: "対象のデータが見つかりません" }, status: :not_found
  end

  private

    def sign_up_params
      params.permit(:email, :password, :password_confirmation, :name)
    end

    def account_update_params
      params.permit(:email, :password, :password_confirmation, :name, :image)
    end
end
