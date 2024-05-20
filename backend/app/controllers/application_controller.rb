class ApplicationController < ActionController::Base 
    include DeviseTokenAuth::Concerns::SetUserByToken
        
    protect_from_forgery unless: -> { request.format.json? }

    def check_login
        return render json: { errors: '未ログイン' }, status: 401 unless api_v1_user_signed_in?
    end
end
