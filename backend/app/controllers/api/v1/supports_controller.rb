class Api::V1::SupportsController < ApplicationController
    before_action :check_login

    def create
        support_user = User.find(params[:id])

        if current_api_v1_user.check_support_mine(support_user)
            return render json: { errors: "自分自身を応援することはできません" }, status: 422
        end

        current_api_v1_user.support!(support_user)

        supporters_count = support_user.supporters.count
   
        render json: { user: support_user.as_json.merge(supportCount: supporters_count) }, status: 200
    rescue ActiveRecord::RecordNotFound
        render json: { errors: '対象のユーザーが見つかりません' }, status: 404
    rescue ActiveRecord::RecordInvalid => e
        render json: { errors: e.record.errors.full_messages }, status: 422
    rescue StandardError => e
        render json: { errors: e.message }, status: 500
    end

    def destroy
        support_user = User.find(params[:id])
        current_api_v1_user.removeSupport!(support_user)

        supporters_count = support_user.supporters.count

        render json: { user: user_json.merge(supportCount: supporters_count) }, status: 200
    rescue ActiveRecord::RecordNotFound
        render json: { errors: '対象のユーザーが見つかりません' }, status: 404
    rescue StandardError => e
        render json: { errors: e.message }, status: 500
    end
    
    def get_user_support
        support_user = User.find(params[:user_id])

        supporters_count = support_user.supporters.count
        includes_user = support_user.supporters.exists?(id: current_api_v1_user.id)

        render json: { user: support_user.as_json.merge(isSupport: includes_user, supportCount: supporters_count) }, status: 200
    rescue ActiveRecord::RecordNotFound
        render json: { errors: '対象のユーザーが見つかりません' }, status: 404
    rescue StandardError => e
        render json: { errors: e.message }, status: 500
    end
end
