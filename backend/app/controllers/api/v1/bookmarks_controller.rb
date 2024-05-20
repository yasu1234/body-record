class Api::V1::BookmarksController < ApplicationController
    before_action :set_user

    def create
        begin
            knowledge = Knowledge.find(bookmark_params[:knowledge_id].to_i)
        rescue ActiveRecord::RecordNotFound
            return render json: { errors: '対象のデータが見つかりません' }, status: 404
        end
        
        if knowledge.bookmarks.create(user_id: current_api_v1_user.id)
            render json: { knowledge: knowledge.as_json().merge(isBookmark: true) }, status: 200
        else
            render json: { errors: knowledge.errors }, status: 422
        end
    end

    def destroy
        begin
            knowledge = Knowledge.find(params[:id].to_i)
        rescue ActiveRecord::RecordNotFound
            return render json: { error: '対象のデータが見つかりません' }, status: 404
        end

        if knowledge.bookmarks.where(knowledge_id: knowledge.id).destroy_all
            bookmark = knowledge.bookmarks.where(knowledge_id: knowledge.id).first
            
            render json: { knowledge: knowledge.as_json().merge(isBookmark: bookmark.present?) }, status: 200
        else
            render json: { errors: knowledge.errors }, status: 422
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