class Api::V1::KnowledgeCommentsController < ApplicationController
    before_action :check_login

    def index         
        comments = Comment.where(knowledge_id: params[:knowledge_id])
        render json: { comments: comments.as_json(include: { user: { only: [:name], methods: :image_url } })}, status: 200
    rescue ActiveRecord::RecordNotFound
        return render json: { error: '対象のデータが見つかりません' }, status: 404
    end

    def create        
        knowledge = Knowledge.find(knowledge_comment_params[:knowledge_id])

        comment = knowledge.comments.build(knowledge_comment_params)
        comment.user_id = current_api_v1_user.id

        render json: { errors: comment.errors.full_message }, status: 422 and return if comment.invalid?

        comment.save!
        
        render json: { comments: knowledge.comments.as_json(include: { user: { only: [:name], methods: :image_url } })}, status: 200
    rescue ActiveRecord::RecordNotFound
        return render json: { error: '対象のデータが見つかりません' }, status: 404
    rescue StandardError => e
        render json: { errors: e.message }, status: 500 
    end

    def destroy
    end

    def knowledge_comment_params
        params.permit(:knowledge_id, :comment)
    end
end
