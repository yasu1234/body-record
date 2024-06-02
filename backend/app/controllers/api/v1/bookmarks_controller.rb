class Api::V1::BookmarksController < ApplicationController
  before_action :check_login

  def create
    knowledge = Knowledge.find(bookmark_params[:knowledge_id])

    bookmark = knowledge.bookmarks.new(user: current_api_v1_user)

    render json: { errors: knowledge.errors.full_message }, status: :unprocessable_entity and return if bookmark.invalid?

    bookmark.save!

    render json: { knowledge: knowledge.as_json.merge(isBookmark: true) }, status: :ok
  rescue ActiveRecord::RecordNotFound
    render json: { errors: "対象のデータが見つかりません" }, status: :not_found
  rescue StandardError => e
    render json: { errors: e.message }, status: :internal_server_error
  end

  def destroy
    knowledge = Knowledge.find(params[:id])

    puts knowledge.bookmarks.first.user_id

    knowledge.bookmarks.where(user_id: params[:user_id]).destroy_all

    bookmark = knowledge.bookmarks.where(user_id: params[:user_id]).first

    render json: { knowledge: knowledge.as_json.merge(isBookmark: bookmark.present?) }, status: :ok
  rescue ActiveRecord::RecordNotFound
    render json: { errors: "対象のデータが見つかりません" }, status: :not_found
  rescue StandardError => e
    render json: { errors: e.message }, status: :internal_server_error
  end

  private

    def bookmark_params
      params.require(:bookmark).permit(:knowledge_id)
    end
end
