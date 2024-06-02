class Api::V1::CommentsController < ApplicationController
  before_action :check_login

  def get_knowledge_comment
    comments = Comment.where(knowledge_id: params[:knowledge_id])
    render json: { comments: comments.as_json(include: { user: { only: [:name], methods: :image_url } }) }, status: :ok
  rescue ActiveRecord::RecordNotFound
    render json: { error: "対象のデータが見つかりません" }, status: :not_found
  end

  def get_record_comment
    comments = Comment.where(record_id: params[:record_id])
    render json: { comments: comments.as_json(include: { user: { only: [:name], methods: :image_url } }) }, status: :ok
  rescue ActiveRecord::RecordNotFound
    render json: { error: "対象のデータが見つかりません" }, status: :not_found
  end

  def create_knowledge_comment
    knowledge = Knowledge.find(knowledge_comment_params[:knowledge_id])

    comment = knowledge.comments.build(knowledge_comment_params)
    comment.user_id = current_api_v1_user.id

    render json: { errors: comment.errors.full_message }, status: :unprocessable_entity and return if comment.invalid?

    comment.save!

    render json: { comments: knowledge.comments.as_json(include: { user: { only: [:name], methods: :image_url } }) }, status: :ok
  rescue ActiveRecord::RecordNotFound
    render json: { error: "対象のデータが見つかりません" }, status: :not_found
  rescue StandardError => e
    render json: { errors: e.message }, status: :internal_server_error
  end

  def create_record_comment
    record = Record.find(record_comment_params[:record_id])
    comment = record.comments.build(record_comment_params)
    comment.user_id = current_api_v1_user.id

    render json: { errors: comment.errors.full_messages }, status: :unprocessable_entity and return if comment.invalid?

    comment.save!

    render json: { record: record.as_json(include: [:comments]) }, status: :ok
  rescue ActiveRecord::RecordNotFound
    render json: { errors: "対象のデータが見つかりません" }, status: :not_found
  end

  def destroy; end

  def knowledge_comment_params
    params.permit(:knowledge_id, :comment)
  end

  def record_comment_params
    params.permit(:record_id, :comment)
  end
end
