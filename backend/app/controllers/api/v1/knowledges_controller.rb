class Api::V1::KnowledgesController < ApplicationController
  before_action :check_login

  def index
    knowledges = Knowledge.all

    if params[:keyword].present?
      knowledges = knowledges.where("title LIKE ?", "%#{params[:keyword]}%")
    end

    if (params[:is_bookmark].present? && params[:is_bookmark] == "true")
      knowledges = knowledges.joins(:bookmarks).where(bookmarks: { user_id: current_api_v1_user.id })
    end

    knowledges = if params[:page].present?
                   knowledges.page(params[:page]).per(30)
                 else
                   knowledges.page(1).per(30)
                 end

    knowledges_with_bookmarks_count = knowledges.map do |knowledge|
      {
        knowledge: knowledge.as_json.merge(
          bookmark_count: knowledge.bookmarks.count,
          is_bookmark: knowledge.bookmarks.where(user_id: current_api_v1_user.id).present?
        )
      }
    end

    totalPage = knowledges.total_pages

    render json: { knowledges: knowledges_with_bookmarks_count, totalPage: totalPage }, status: :ok
  end

  def create
    knowledge = current_api_v1_user.knowledges.build(knowledge_register_params)

    render json: { errors: knowledge.errors.full_messages }, status: :unprocessable_entity and return if knowledge.invalid?

    knowledge.save!
    render json: { knowledge: }, status: :ok
  rescue StandardError => e
    render json: { errors: e.message }, status: :internal_server_error
  end

  def show
    knowledge = Knowledge.find(params[:id])

    bookmark = knowledge.bookmarks.where(knowledge_id: knowledge.id).first
    render json: { knowledge: knowledge.as_json(
      include: {
        user: { only: [:name], methods: :image_url }
      }, methods: :image_urls
    ).merge(
      is_bookmark: bookmark.present?,
      is_my_knowledge: knowledge.user_id == current_api_v1_user.id,
      bookmark_count: knowledge.bookmarks.count
    )}, status: :ok
  rescue ActiveRecord::RecordNotFound
    render json: { errors: "対象のデータが見つかりません" }, status: :not_found
  end

  def update
    knowledge = current_api_v1_user.knowledges.find(params[:id])
    knowledge.update!(knowledge_register_params)

    render json: { knowledge: }, status: :ok
  rescue ActiveRecord::RecordNotFound
    render json: { errors: "対象のデータが見つかりません" }, status: :not_found
  rescue ActiveRecord::RecordInvalid => e
    render json: { errors: e.record.errors.full_messages }, status: :unprocessable_entity
  rescue StandardError => e
    render json: { errors: e.message }, status: :internal_server_error
  end

  def destroy
    knowledge = current_api_v1_user.knowledges.find(params[:id])
    knowledge.destroy!

    render json: { knowledge: }, status: :ok
  rescue ActiveRecord::RecordNotFound
    render json: { errors: "対象のデータが見つかりません" }, status: :not_found
  rescue ActiveRecord::RecordNotDestroyed => e
    render json: { errors: e.message }, status: :unprocessable_entity
  rescue StandardError => e
    render json: { errors: e.message }, status: :internal_server_error
  end

  private

    def knowledge_register_params
      params.require(:knowledge).permit(:title, :content, images: [])
    end
end
