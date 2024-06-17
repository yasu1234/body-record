class Api::V1::KnowledgeCommentsController < ApplicationController
  before_action :check_login

  def index
    if params[:knowledge_id].nil?
      render json: { errors: "記録を指定してください" }, status: :bad_request and return
    end

    comments = Comment.where(knowledge_id: params[:knowledge_id])
    render json: { comments: comments.as_json(include: { user: { only: [:name], methods: :image_url } }) }, status: :ok
  rescue StandardError => e
    render json: { errors: e.message }, status: :internal_server_error
  end

  def create
    knowledge = Knowledge.find(knowledge_comment_params[:knowledge_id])

    comment = knowledge.comments.build(knowledge_comment_params)
    comment.user_id = current_api_v1_user.id

    render json: { errors: comment.errors.full_message }, status: :unprocessable_entity and return if comment.invalid?

    comment.save!

    render json: { knowledge: knowledge.as_json(include: [:comments]) }, status: :ok
  rescue ActiveRecord::RecordNotFound
    render json: { error: "対象のデータが見つかりません" }, status: :not_found
  rescue StandardError => e
    render json: { errors: e.message }, status: :internal_server_error
  end

  private

    def knowledge_comment_params
      params.permit(:knowledge_id, :comment)
    end
end
