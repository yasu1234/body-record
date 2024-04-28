class Api::V1::KnowledgesController < ApplicationController
    def index
        @totalCount = 0

        if api_v1_user_signed_in?
            @user = current_api_v1_user
        else
        end

        @knowledges = Knowledge.all

        if params[:keyword].present? 
            @knowledges = @knowledges.where("title LIKE ?", "%#{params[:keyword]}%")
        end

        if params[:page].present?
            @knowledges = @knowledges.page(params[:page]).per(50)
        else
            @knowledges = @knowledges.page(1).per(50)
        end

        @totalPage = @knowledges.total_pages

        render json: { knowledges: @knowledges, totalPage: @totalPage }, status: 200
    end

    def create
        @user = current_api_v1_user
        @knowledge = Knowledge.new(knowledge_register_params)
        @knowledge.create_user_id = @user.id
        @knowledge.save
        render json: { knowledge: @knowledge }, status: 200
    end

    def show
        @user = current_api_v1_user
        @knowledge = Knowledge.where(id: params[:id].to_i).first
        @bookmark = @knowledge.bookmarks.where(knowledge_id: @knowledge.id).first
        render json: { knowledge: @knowledge.as_json(include: [:comments]), imageUrls: @knowledge.image_urls, isBookmark: @bookmark.present? }, status: 200
    end

    def delete_image
        @knowledge = Knowledge.find(params[:id])
        @image = @knowledge.images.find(params[:image_id])
        @image.purge
        render json: { knowledge: @knowledge, imageUrls: @knowledge.image_urls }, status: 200
    end

    def update
        @user = current_api_v1_user
        @knowledge = Knowledge.where(id: params[:id].to_i).first
        @knowledge.update(knowledge_register_params)
        render json: { knowledge: @knowledge }, status: 200
    end

    def get_target_user_knowledge
        @knowledges = Knowledge.where(create_user_id: params[:user_id])

        # ユーザーページで表示するデータを取得する処理なので、最大5件分のみレスポンスとしてレンダリングする
        if @knowledges.count > 5
            @knowledges = @knowledges.limit(5)
        end

        render json: { knowledges: @knowledges }, status: 200
    end

    def knowledge_register_params
        params.permit(:title, :content, :images)
    end
end