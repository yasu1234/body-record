class Api::V1::BookmarksController < ApplicationController
    before_action :check_login

    def create
        knowledge = Knowledge.find(bookmark_params[:knowledge_id].to_i)
        
        bookmark = knowledge.bookmarks.new(user: current_api_v1_user)
        
        render json: { errors: knowledge.errors.full_message }, status: 422 and return if bookmark.invalid?

        bookmark.save!

        render json: { knowledge: knowledge.as_json.merge(isBookmark: true) }, status: 200
    rescue ActiveRecord::RecordNotFound
        return render json: { errors: '対象のデータが見つかりません' }, status: 404
    rescue StandardError => e
        render json: { errors: e.message }, status: 500
    end

    def destroy
        knowledge = Knowledge.find(params[:id].to_i)

        knowledge.bookmarks.where(user_id: params[:user_id]).destroy_all

        bookmark = knowledge.bookmarks.where(knowledge_id: knowledge.id).first

        render json: { knowledge: knowledge.as_json.merge(isBookmark: bookmark.present?) }, status: 200
    rescue ActiveRecord::RecordNotFound
        return render json: { errors: '対象のデータが見つかりません' }, status: 404
    rescue StandardError => e
        render json: { errors: e.message }, status: 500
    end

    private

    def bookmark_params
        params.require(:bookmark).permit(:knowledge_id)
    end
end
