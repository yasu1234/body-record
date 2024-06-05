class Api::V1::UsersController < ApplicationController
    before_action :check_login

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
