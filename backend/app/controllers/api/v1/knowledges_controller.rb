class Api::V1::KnowledgesController < ApplicationController
  before_action :check_login

  def index
    knowledges = Knowledge.all

    if params[:keyword].present?
      knowledges = knowledges.where("title LIKE ?", "%#{params[:keyword]}%")
    end

    if params[:is_bookmark].present? && ActiveModel::Type::Boolean.new.cast(params[:is_bookmark])
      knowledges = knowledges.joins(:bookmarks).where(bookmarks: { user_id: current_api_v1_user.id })
    end

    if params[:is_show_mine].present? && ActiveModel::Type::Boolean.new.cast(params[:is_show_mine])
      knowledges = knowledges.where(user_id: current_api_v1_user.id)
    end

    if params[:user_id].present?
      knowledges = knowledges.where(user_id: params[:user_id])
    end

    if params[:sort_type].present? && params[:sort_type].to_i == Knowledge::SortType::BOOKMARK_COUNT
      #ブックマークが多い順に並び替え
      knowledges = knowledges.left_joins(:bookmarks)
      .group('knowledges.id')
      .select('knowledges.*, COUNT(bookmarks.id) AS bookmark_count')
      .order('COUNT(bookmarks.id) DESC')
      .latest_knowledges
      total_count = knowledges.size.length
    else
      knowledges = knowledges.latest_knowledges
      total_count = knowledges.size
    end

    knowledges = if params[:page].present?
                   knowledges.page(params[:page]).per(30)
                 else
                   knowledges.page(1).per(30)
                 end

    total_page = knowledges.total_pages

    render json: {
      knowledges: knowledges.map do |knowledge|
        knowledge.as_json(
          include: {
            user: { only: [:name], methods: :image_url }
          },
          methods: :create_date_format
        ).merge(
          bookmark_count: knowledge.bookmarks.count,
          is_bookmark: knowledge.bookmarks.where(user_id: current_api_v1_user.id).present?
        )
      end, total_page:, total_count:
    }, status: :ok
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
      }, methods:[:image_urls, :create_date_format]
    ).merge(
      is_bookmark: bookmark.present?,
      is_my_knowledge: knowledge.user_id == current_api_v1_user.id,
      bookmark_count: knowledge.bookmarks.count
    ) }, status: :ok
  rescue ActiveRecord::RecordNotFound
    render json: { errors: "対象のデータが見つかりません" }, status: :not_found
  end

  def update
    knowledge = current_api_v1_user.knowledges.find(params[:id])

    # 画像がある場合は既存の画像は残したまま追加
    if params[:knowledge][:images].present?
      new_images = params[:knowledge][:images]
      knowledge.images.attach(new_images)
      params[:knowledge].delete(:images)
    end

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
  end

  private

    def knowledge_register_params
      params.require(:knowledge).permit(:title, :content, images: [])
    end
end
