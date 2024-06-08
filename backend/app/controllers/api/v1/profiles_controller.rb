class Api::V1::ProfilesController < ApplicationController
  before_action :check_login

  def show
    user = User.find(params[:id])
    render json: { user: user.as_json({ only: [:name, :id], methods: :image_url }).merge(is_my_profile: user.id == current_api_v1_user.id, profile: user.profile) }, status: :ok
  rescue ActiveRecord::RecordNotFound
    render json: { errors: "対象のデータが見つかりません" }, status: :not_found
  rescue StandardError => e
    render json: { errors: e.message }, status: :internal_server_error
  end

  def create
      ## プロフィールがあれば更新、なければ作成
    Profile.find_or_create_by!(user: current_api_v1_user).tap do |profile|
      profile.update!(profile_register_params)
    end

    render json: { user: current_api_v1_user.profile.as_json(include: { user: { only: [:name], methods: :image_url } }) }, status: :ok
  rescue ActiveRecord::RecordInvalid => e
    render json: { errors: e.record.errors.full_messages }, status: :unprocessable_entity
  rescue StandardError => e
    render json: { errors: e.message }, status: :internal_server_error
  end

  private

    def profile_register_params
      params.permit(:profile, :goal_weight, :goal_fat_percentage)
    end
end
