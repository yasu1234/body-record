class Api::V1::RecordCommentsController < ApplicationController
    before_action :check_login

    def index
        comments = Comment.where(record_id: params[:record_id])
        render json: { comments: comments.as_json(include: { user: { only: [:name], methods: :image_url } }) }, status: :ok
    rescue ActiveRecord::RecordNotFound
        render json: { error: "対象のデータが見つかりません" }, status: :not_found
    end
    
    
    def create
        record = Record.find(record_comment_params[:record_id])
        comment = record.comments.build(record_comment_params)
        comment.user_id = current_api_v1_user.id
    
        render json: { errors: comment.errors.full_messages }, status: :unprocessable_entity and return if comment.invalid?
    
        comment.save!
    
        render json: { record: record.as_json(include: [:comments]) }, status: :ok
    rescue ActiveRecord::RecordNotFound
        render json: { errors: "対象のデータが見つかりません" }, status: :not_found
    end
    
    private
    
    def record_comment_params
        params.permit(:record_id, :comment)
    end
end
