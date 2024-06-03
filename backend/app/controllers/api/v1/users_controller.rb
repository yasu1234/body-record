class Api::V1::UsersController < ApplicationController
    before_action :check_login

    def index
        users = User.all
    
        if params[:isSupportOnly].present? && params[:isSupportOnly] == "true"
          users = users.supporing
        end
    
        if params[:keyword].present?
          users = users.where("name LIKE ?", "%#{params[:keyword]}%")
        end
    
        users = if params[:page].present?
                  users.page(params[:page]).per(30)
                else
                  users.page(1).per(30)
                end
    
        total_page = users.total_pages
        render json: { users: users.as_json(only: %i[id name], methods: :image_url), total_page: total_page}, status: :ok
      end
  
    def show
      user = User.find(params[:id])
  
      render json: { user: user.as_json(only: %i[id name], methods: :image_url)}, status: :ok
    rescue ActiveRecord::RecordNotFound
      render json: { errors: "対象のユーザーが見つかりません" }, status: :not_found
    rescue StandardError => e
      render json: { errors: e.message }, status: :internal_server_error
    end
  end
