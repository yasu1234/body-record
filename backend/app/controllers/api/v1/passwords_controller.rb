module Api::V1
    class PasswordsController < DeviseTokenAuth::PasswordsController
      def update
        if api_v1_user_signed_in?
            @user = current_api_v1_user
        else
        end
        if password_edit_params[:password].present?
          if @user.update_with_password(password_edit_params)
            render json: { user: @user }, status: 200
          else
            render json: { errors: @user.errors }, status: 422
          end
        else
        end
      end
  
      private
  
      def password_edit_params
        params.permit(:password, :password_confirmation, :current_password)
      end
    end
  end