class Api::V1::BookmarksController < ApplicationController
    before_action :set_user

    def create
        @knowledge = Knowledge.where(id: bookmark_params[:knowledge_id]).first
        if @knowledge.nil?
            return render json: { isBookmark: false }, status: 404
        else
            if @knowledge.bookmarks.create(user_id: @user.id)
                render json: { knowledge: @knowledge, isBookmark: true }, status: 200
            else
                render json: { errors: @knowledge.errors, isBookmark: false }, status: 422
            end
        end
    end

    def destroy
        begin
            @knowledge = Knowledge.find(params[:id].to_i)
        rescue ActiveRecord::RecordNotFound
            return render json: { error: '対象のデータが見つかりません' }, status: 404
        end

        if @knowledge.bookmarks.where(knowledge_id: @knowledge.id).destroy_all
            @bookmark = @knowledge.bookmarks.where(knowledge_id: @knowledge.id).first
            
            render json: { knowledge: @knowledge, isBookmark: @bookmark.present? }, status: 200
        else
            render json: { errors: @knowledge.errors }, status: 422
        end
    end

    private

    def set_user
        if api_v1_user_signed_in?
            @user = current_api_v1_user
        else
            return render json: { errors: "未ログイン" }, status: 401
        end
    end

    def bookmark_params
        params.require(:bookmark).permit(:knowledge_id)
    end
end