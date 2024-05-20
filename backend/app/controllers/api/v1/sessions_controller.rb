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
            render json: { user: nil }, status: 200
        end
    end

    def get_users
        users = User.all

        if params[:isSupportOnly].present? && params[:isSupportOnly] == "true"
            users = users.supporing
        end

        if params[:keyword].present? 
            users = users.where("name LIKE ?", "%#{params[:keyword]}%")
        end

        
        if params[:page].present?
            users = users.page(params[:page]).per(30)
        else
            users = users.page(1).per(30)
        end

        total_page = users.total_pages
        render json: { users: users, total_page: total_page }, status: 200
    end
end