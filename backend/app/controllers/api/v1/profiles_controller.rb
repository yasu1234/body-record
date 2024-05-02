class Api::V1::ProfilesController < ApplicationController
    before_action :set_user

    def show
        render json: { profile: @user.profile, user: @user }, status: 200
    end

    def create
        if @user.profile.present?
            @user.profile.update(profile_register_params)
            render json: { profile: @user.profile, user: @user }, status: 200
        else
            @user.profile = Profile.new(profile_register_params)
            if @user.profile.save
                render json: { profile: @user.profile, user: @user }, status: 200
            else
                render json: { errors: @user.profile.errors.to_hash(true) }, status: 422
            end
        end
    end

    private

    def set_user
        if api_v1_user_signed_in?
            @user = current_api_v1_user
        else
            render json: { errors: "未ログイン" ,status: 401 }
        end
    end

    def profile_register_params
        params.permit(:profile, :goal_weight, :goal_fat_percentage, :image)
    end
end

