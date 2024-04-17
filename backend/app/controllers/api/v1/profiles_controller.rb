class Api::V1::ProfilesController < ApplicationController

    def show
        if api_v1_user_signed_in?
            @user = current_api_v1_user
        else
        end

        @profile = Profile.where(user_id: params[:id].to_i).first
        render json: { profile: @profile, user: @user }, status: 200
    end
end