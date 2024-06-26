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

    users = if params[:sort_type].present? && params[:sort_type].to_i == User::SortType::SUPPORTER_COUNT
              users.left_joins(:supporter_relationships)
                   .group("users.id")
                   .select("users.*, COUNT(supports.id) AS supporters_count")
                   .order("supporters_count DESC")
            else
              users.order(created_at: :desc)
            end

    users = if params[:page].present?
              users.page(params[:page]).per(30)
            else
              users.page(1).per(30)
            end

    render json: {
      users: users.map do |user|
        user.as_json(
          only: %i[id name],
          methods: :image_url
        ).merge(
          supporter_count: user.supporter_relationships.count,
          is_support: user.supporter_relationships.exists?(user_id: current_api_v1_user.id),
          latest_record: user.records.order(date: :desc).first&.as_json(methods: :formatted_date)
        )
      end, total_page: users.total_pages, total_count: users.size
    }, status: :ok
  end

  def show
    user = User.find(params[:id])

    render json: { user: user.as_json(only: %i[id name], methods: :image_url) }, status: :ok
  rescue ActiveRecord::RecordNotFound
    render json: { errors: "対象のユーザーが見つかりません" }, status: :not_found
  end
end
