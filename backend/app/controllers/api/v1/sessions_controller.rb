class Api::V1::SessionsController < DeviseTokenAuth::SessionsController
  protect_from_forgery

  wrap_parameters format: []

  def guest_sign_in
    @resource = User.guest!
    @token = @resource.create_token
    @resource.save!
    render_create_success
  rescue StandardError => e
    render json: { errors: e.message }, status: :internal_server_error
  end

  def check_login
    if api_v1_user_signed_in?
      render json: { user: current_api_v1_user.as_json(include: [:profile]) }, status: :ok
    else
      render json: { user: nil }, status: :ok
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

    users = if params[:page].present?
              users.page(params[:page]).per(30)
            else
              users.page(1).per(30)
            end

    total_page = users.total_pages
    render json: { users: users.as_json(only: %i[id name], methods: :image_url), total_page: }, status: :ok
  end
end
