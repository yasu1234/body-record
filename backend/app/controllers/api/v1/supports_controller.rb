class Api::V1::SupportsController < ApplicationController
  before_action :check_login

  def create
    support_user = User.find(params[:id])

    supporting = current_api_v1_user.support(support_user)

    if supporting.nil?
      return render json: { errors: "自分自身を応援することはできません" }, status: :unprocessable_entity
    end

    render json: { errors: supporting.errors.full_messages }, status: :unprocessable_entity and return if supporting.invalid?

    supporting.save!
    supporters_count = support_user.supporters.count
    supports_count = support_user.supportings.count
    includes_user = support_user.supporters.exists?(id: current_api_v1_user.id)

    render json: { user: support_user.as_json.merge(isSupport: includes_user, supporterCount: supporters_count, supportCount: supports_count) }, status: :ok
  rescue ActiveRecord::RecordNotFound
    render json: { errors: "対象のユーザーが見つかりません" }, status: :not_found
  rescue StandardError => e
    render json: { errors: e.message }, status: :internal_server_error
  end

  def destroy
    support_user = User.find(params[:id])

    supporting = current_api_v1_user.removeSupport(support_user)

    if supporting.nil?
      return render json: { errors: "応援していないユーザーなので解除できません" }, status: :unprocessable_entity
    end

    if supporting.destroy
      user_json = support_user.as_json(
        include: [
          { supportings: { include: %i[supportings supporters] } },
          { supporters: { include: %i[supportings supporters] } }
        ]
      )
      includes_user = user_json["supporters"].any? { |supporter| supporter["id"] == current_api_v1_user.id }
      supporters_count = support_user.supporters.count
      supports_count = support_user.supportings.count
      render json: { user: user_json.merge(isSupport: includes_user, supporterCount: supporters_count, supportCount: supports_count) }, status: :ok
    else
      render json: { errors: supporting.errors.full_messages }, status: :unprocessable_entity
    end
  rescue ActiveRecord::RecordNotFound
    render json: { errors: "対象のユーザーが見つかりません" }, status: :not_found
  rescue StandardError => e
    render json: { errors: e.message }, status: :internal_server_error
  end

  def get_user_support
    target_user = User.find(params[:user_id])

    supporters_count = target_user.supporters.count
    supports_count = target_user.supportings.count
    includes_user = target_user.supporters.exists?(id: current_api_v1_user.id)

    render json: { user: target_user.as_json.merge(isSupport: includes_user, supporterCount: supporters_count, supportCount: supports_count) }, status: :ok
  rescue ActiveRecord::RecordNotFound
    render json: { errors: "対象のユーザーが見つかりません" }, status: :not_found
  rescue StandardError => e
    render json: { errors: e.message }, status: :internal_server_error
  end
end
