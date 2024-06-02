class Api::V1::ProfilesController < ApplicationController
    before_action :check_login

    def show
        render json: {user: current_api_v1_user.profile.as_json(include: { user: { only: [:name], methods: :image_url }})}, status: 200
    end

    def create
        if current_api_v1_user.profile.present?
            if current_api_v1_user.profile.update(profile_register_params)
                render json: {user: current_api_v1_user.profile.as_json(include: { user: { only: [:name], methods: :image_url } })}, status: 200
            else
                render json: { errors: current_api_v1_user.profile.errors.full_messages }, status: 422
            end
        else
            current_api_v1_user.profile = Profile.new(profile_register_params)
            if current_api_v1_user.profile.save
                render json: {user: current_api_v1_user.profile.as_json(include: { user: { only: [:name], methods: :image_url } })}, status: 200
            else
                render json: { errors: current_api_v1_user.profile.errors.full_messages }, status: 422
            end
        end
    end

    private

    def profile_register_params
        params.permit(:profile, :goal_weight, :goal_fat_percentage)
    end
end

