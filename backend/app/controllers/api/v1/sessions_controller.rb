class Api::V1::SessionsController < DeviseTokenAuth::SessionsController
    protect_from_forgery
  
    wrap_parameters format: []

    def guest_sign_in
        @resource = User.guest
        @token = @resource.create_token
        @resource.save!
        render_create_success
    end

    def chck_login
        if api_v1_user_signed_in?
            render json: { isLogin: true }, status: 200
        else
            render json: { isLogin: false }, status: 200
        end
    end
end