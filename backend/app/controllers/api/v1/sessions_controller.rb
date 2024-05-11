class Api::V1::SessionsController < DeviseTokenAuth::SessionsController
    protect_from_forgery
  
    wrap_parameters format: []

    def guest_sign_in
        @resource = User.guest
        @token = @resource.create_token
        if @resource.save
            render_create_success
        else
            render_create_error
        end
    end

    def check_login
        if api_v1_user_signed_in?
            @user = current_api_v1_user
            render json: { user: @user.as_json(include: [:profile]) }, status: 200
        else
            render status: 200
        end
    end
end