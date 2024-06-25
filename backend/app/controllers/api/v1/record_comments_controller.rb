class Api::V1::RecordCommentsController < ApplicationController
  before_action :check_login

  def index
    if params[:record_id].nil?
      render json: { errors: "記録を指定してください" }, status: :bad_request and return
    end

    comments = Comment.where(record_id: params[:record_id])
    render json: {
      comments: comments.map do |comment|
        comment.as_json(
          methods: :comment_date_format,
          include: {
            user: {
              only: [:name],
              methods: :image_url
            }
          }
        ).merge(is_mine_comment: comment.user_id == current_api_v1_user.id)
      end
    }, status: :ok
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

  def update
    comment = Comment.find(params[:id])
    comment.update!(record_comment_params)

    render json: { comment: }, status: :ok
  rescue ActiveRecord::RecordNotFound
    render json: { errors: "対象のデータが見つかりません" }, status: :not_found
  rescue ActiveRecord::RecordInvalid => e
    render json: { errors: e.record.errors.full_messages }, status: :unprocessable_entity
  end

  def destroy
    comment = Comment.find(params[:id])

    comment.destroy!

    render json: { comment: }, status: :ok
  rescue ActiveRecord::RecordNotFound
    render json: { errors: "対象のデータが見つかりません" }, status: :not_found
  rescue ActiveRecord::RecordNotDestroyed => e
    render json: { errors: e.message }, status: :unprocessable_entity
  end

  private

    def record_comment_params
      params.require(:comment).permit(:record_id, :comment)
    end
end
