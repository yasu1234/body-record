class Api::V1::KnowledgesController < ApplicationController
    def index
        @totalCount = 0

        if api_v1_user_signed_in?
            @user = current_api_v1_user
        else
        end

        @knowledge = Knowledge.all

        if params[:keyword].present? 
            @knowledge = @knowledge.where("title LIKE ?", "%#{params[:keyword]}%")
        end

        @totalCount = @knowledge.count

        render json: { knowledges: @knowledge, totalCount: @totalCount }, status: 200
    end

    def create
        @user = current_api_v1_user
        @knowledge = Knowledge.new(knowledge_register_params)
        @knowledge.create_user_id = @user.id
        @knowledge.save
        render json: { knowledge: @knowledge }, status: 200
    end

    def knowledge_register_params
        params.permit(:title, :content, :images)
    end
end