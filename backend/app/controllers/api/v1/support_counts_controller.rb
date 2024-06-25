class Api::V1::SupportCountsController < ApplicationController
  before_action :check_login

  def index
    support_user = User.find(params[:user_id])

    includes_user = support_user.supporter_relationships.exists?(user_id: current_api_v1_user.id)

    render json: {
      user: support_user.as_json({ only: %i[id name] }).merge(
        is_support: includes_user,
        supporter_count: support_user.supporter_relationships.count,
        support_count: support_user.supportings.count
      )
    }, status: :ok
  rescue ActiveRecord::RecordNotFound
    render json: { errors: "対象のユーザーが見つかりません" }, status: :not_found
  end
end
