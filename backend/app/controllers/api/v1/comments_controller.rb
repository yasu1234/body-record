class Api::V1::CommentsController < ApplicationController
    before_action :check_user

    def create_knowledge_comment
        @knowledge = Knowledge.where(id: knowledge_comment_params[:knowledge_id].to_i).first

        @comment = @knowledge.comments.build(knowledge_comment_params)
        @comment.user_id = @user.id

        if @comment.save
            render json: {
                knowledge: @knowledge.as_json(include: [:comments])
            }, status: 200
        else
            render json: { error: @comment.errors.full_messages}, status: 422
        end
    end

    def create_record_comment
    end

    def destroy
    end

    def knowledge_comment_params
        params.permit(:knowledge_id, :comment)
    end

    def record_comment_params
        params.permit(:user_id, :record_id, :comment)
    end

    private 

    def check_user
        if api_v1_user_signed_in?
            @user = current_api_v1_user
        else
        end
    end
end