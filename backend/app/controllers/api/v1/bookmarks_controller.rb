class Api::V1::BookmarksController < ApplicationController
    def create
        if api_v1_user_signed_in?
            @user = current_api_v1_user
        else
            return render json: { isBookmark: false }, status: 401
        end

        @knowledge = Knowledge.where(id: bookmark_params[:knowledge_id]).first
        @knowledge.bookmarks.create(user_id: @user.id)

        render json: { knowledge: @knowledge, isBookmark: true }, status: 200
    end

    def bookmark_params
        params.permit(:user_id, :knowledge_id)
    end
end