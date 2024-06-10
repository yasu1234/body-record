class Api::V1::SupportCountsController < ApplicationController
    before_action :check_login
  
    def index
      support_user = User.find(params[:user_id])
  
      includes_user = support_user.supporter_relationships.exists?(id: current_api_v1_user.id)
  
      render json: { user: support_user.as_json({ only: [:id, :name]}).merge(
        isSupport: includes_user,
        supporterCount: support_user.supporter_relationships.count,
        supportCount: support_user.supportings.count) }, status: :ok
    rescue ActiveRecord::RecordNotFound
      render json: { errors: "対象のユーザーが見つかりません" }, status: :not_found
    rescue StandardError => e
      render json: { errors: e.message }, status: :internal_server_error
    end
  end
