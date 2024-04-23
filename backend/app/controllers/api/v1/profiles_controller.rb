class Api::V1::ProfilesController < ApplicationController

    def show
        if api_v1_user_signed_in?
            @user = current_api_v1_user
        else
        end

        @profile = @user.profile
        render json: { profile: @profile, user: @user }, status: 200
    end

    def create
        if api_v1_user_signed_in?
            @user = current_api_v1_user
        else
        end

        if @user.profile.present?
            @user.profile.update(profile_register_params)
            render json: { profile: @user.profile, user: @user }, status: 200
        else
            @user.profile = Profile.new(profile_register_params)
            if @user.profile.save
                render json: { profile: @user.profile, user: @user }, status: 200
            else
                render json: { errors: @user.profile.errors.full_messages }, status: 422
            end
        end
    end

    def profile_register_params
        params.permit(:profile, :goal_weight, :goal_fat_percentage, :image)
    end
end

