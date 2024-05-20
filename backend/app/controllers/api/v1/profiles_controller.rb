class Api::V1::ProfilesController < ApplicationController
    before_action :check_login

    def show
        render json: {user: current_api_v1_user.profile.as_json(include: { user: { only: [:name], methods: :image_url }})}, status: 200
    end

    def create
        if current_api_v1_user.profile.nil?
            update_profile
        end

        current_api_v1_user.profile.update(profile_register_params)
        render json: { errors: current_api_v1_user.profile.errors.full_messages }, status: 422 and return if current_api_v1_user.profile.invalid?

        current_api_v1_user.profile.save!
        render json: {user: current_api_v1_user.profile.as_json(include: { user: { only: [:name], methods: :image_url } })}, status: 200
    rescue StandardError => e
        render json: { errors: e.message }, status: 500 
    end

    private

    def profile_register_params
        params.permit(:profile, :goal_weight, :goal_fat_percentage)
    end

    def update_profile
        current_api_v1_user.profile = Profile.new(profile_register_params)
        render json: { errors: current_api_v1_user.profile.errors.full_messages }, status: 422 and return if current_api_v1_user.profile.invalid?

        current_api_v1_user.profile.save!
        render json: {user: current_api_v1_user.profile.as_json(include: { user: { only: [:name], methods: :image_url } })}, status: 200
    rescue StandardError => e
        render json: { errors: e.message }, status: 500 
    end
end
