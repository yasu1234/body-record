class Api::V1::UsersController < ApplicationController
  before_action :check_login

  def index
    users = User.all

    if params[:isSupportOnly].present? && params[:isSupportOnly] == "true"
      users = current_api_v1_user.supportings
    end

    if params[:keyword].present?
      users = users.where("name LIKE ?", "%#{params[:keyword]}%")
    end

    users = if params[:page].present?
              users.page(params[:page]).per(30)
            else
              users.page(1).per(30)
            end

      # ユーザーの最新の記録を取得する
    user_records = users.includes(:records).map do |user|
      {
        user: user.as_json(only: %i[id name], methods: :image_url),
        supporter_count: user.supporter_relationships.count,
        is_support: user.supporter_relationships.exists?(user_id: current_api_v1_user.id),
        latest_record: user.records.order(date: :desc).first&.as_json(methods: :formatted_date)
      }
    end

    total_page = users.total_pages
    render json: { users: user_records, total_page: }, status: :ok
  end

  def show
    user = User.find(params[:id])

    render json: { user: user.as_json(only: %i[id name], methods: :image_url) }, status: :ok
  rescue ActiveRecord::RecordNotFound
    render json: { errors: "対象のユーザーが見つかりません" }, status: :not_found
  rescue StandardError => e
    render json: { errors: e.message }, status: :internal_server_error
  end
end
