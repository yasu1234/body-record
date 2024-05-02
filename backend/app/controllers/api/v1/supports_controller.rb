class Api::V1::SupportsController < ApplicationController
    before_action :set_user

    def create
        supporting = @user.support(@support_user)
        if supporting.save
            user_json = @support_user.as_json(
                include: [
                    { supportings: { include: %i[supportings supporters] } },
                    { supporters: { include: %i[supportings supporters] } }
                ]
            )
            includes_user = user_json["supporters"].any? { |supporter| supporter["id"] == @user.id }
            render json: { user: user_json, isSupport: includes_user ,status: 200 }
        else
            render json: { errors: supporting.erros }, status: 422
        end
    end

    def destroy
        supporting = @user.removeSupport(@support_user)
        if supporting.destroy
            user_json = @support_user.as_json(
                include: [
                    { supportings: { include: %i[supportings supporters] } },
                    { supporters: { include: %i[supportings supporters] } }
                ]
            )
            includes_user = user_json["supporters"].any? { |supporter| supporter["id"] == @user.id }
            render json: { user: user_json, isSupport: includes_user , status: 200 }
        else
            render json: { errors: supporting.erros }, status: 422
        end
    end

    private

    def set_user
        if api_v1_user_signed_in?
            @user = current_api_v1_user
        else
            render json: { errors: "未ログイン" }, status: 401
        end
        @support_user = User.find(params[:id])
    end
end