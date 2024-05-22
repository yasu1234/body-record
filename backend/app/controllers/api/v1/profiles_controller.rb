class Api::V1::ProfilesController < ApplicationController
    before_action :check_login

    def show
        render json: {user: current_api_v1_user.profile.as_json(include: { user: { only: [:name], methods: :image_url }})}, status: 200
    end

    def create
        Profile.find_or_create_by!(user: current_api_v1_user).tap do |profile|
           profile.update!(profile_register_params)
        end
   
        render json: {user: current_api_v1_user.profile.as_json(include: { user: { only: [:name], methods: :image_url } })}, status: 200
    rescue ActiveRecord::RecordInvalid => e
        render json: { errors: e.record.errors.full_messages }, status: 422
    rescue StandardError => e
        render json: { errors: e.message }, status: 500 
    end

    private

    def profile_register_params
        params.permit(:profile, :goal_weight, :goal_fat_percentage)
    end
end
