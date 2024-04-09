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
end