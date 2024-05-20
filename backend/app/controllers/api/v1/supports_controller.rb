class Api::V1::SupportsController < ApplicationController
    before_action :check_login

    def create
        support_user = User.find(params[:id])
        supporting = current_api_v1_user.support(support_user)

        if supporting.nil?
            return render json: { errors: "自分自身を応援することはできません" }, status: 422
        end

        render json: { errors: supporting.errors.full_messages }, status: 422 and return if supporting.invalid?
        
        supporting.save!
        supporters_count = support_user.supporters.count
        includes_user = support_user.supporters.exists?(id: current_api_v1_user.id)

        render json: { user: support_user.as_json.merge(isSupport: includes_user, supportCount: supporters_count) }, status: 200
    rescue ActiveRecord::RecordNotFound
        render json: { errors: '対象のユーザーが見つかりません' }, status: 404
    rescue StandardError => e
        render json: { errors: e.message }, status: 500
    end

    def destroy
        support_user = User.find(params[:id])
        supporting = current_api_v1_user.removeSupport(support_user)

        if supporting.nil?  
            return render json: { errors: "応援していないユーザーなので解除できません" }, status: 422
        end

        if supporting.destroy
            user_json = support_user.as_json(
                include: [
                    { supportings: { include: %i[supportings supporters] } },
                    { supporters: { include: %i[supportings supporters] } }
                ]
            )
            includes_user = user_json["supporters"].any? { |supporter| supporter["id"] == current_api_v1_user.id }
            render json: { user: user_json.merge(isSupport: includes_user) }, status: 200
        else
            render json: { errors: supporting.errors.full_messages }, status: 422
        end
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
