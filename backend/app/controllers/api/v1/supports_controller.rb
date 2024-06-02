class Api::V1::SupportsController < ApplicationController
    before_action :check_login

    def create
        support_user = User.find(params[:id])

        if support_user.nil?
            return render json: { errors: "対象のユーザーが見つかりません" }, status: 404
        end
        supporting = current_api_v1_user.support(support_user)

        if supporting.nil?
            return render json: { errors: "自分自身を応援することはできません" }, status: 422
        end
        
        if supporting.save
            supporters_count = support_user.supporters.count
            includes_user = support_user.supporters.exists?(id: current_api_v1_user.id)

            render json: { user: support_user.as_json.merge(isSupport: includes_user, supportCount: supporters_count) }, status: 200
        else
            render json: { errors: supporting.erros.full_messages }, status: 422
        end
    end

    def destroy
        support_user = User.find(params[:id])

        if support_user.nil?
            return render json: { errors: "対象のユーザーが見つかりません" }, status: 404
        end

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
            render json: { errors: supporting.erros.full_messages }, status: 422
        end
    end

    def get_user_support
        support_user = User.find(params[:user_id])

        if support_user.nil?
            return render json: { errors: "対象のユーザーが見つかりません" }, status: 404
        end

        supporters_count = support_user.supporters.count
        supports_count = support_user.supports.count
        includes_user = support_user.supporters.exists?(id: current_api_v1_user.id)

        render json: { user: support_user.as_json().merge(isSupport: includes_user, supporterCount: supporters_count, supportCount: supports_count) }, status: 200
    end
end
