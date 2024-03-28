class Api::V1::SessionsController < DeviseTokenAuth::SessionsController
    protect_from_forgery
  
    wrap_parameters format: []

    def guest_sign_in
        @resource = User.guest
        @token = @resource.create_token
        @resource.save!
        render_create_success
    end
  
end