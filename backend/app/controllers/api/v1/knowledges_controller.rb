class Api::V1::KnowledgesController < ApplicationController
  before_action :check_login

  def index
    knowledges = Knowledge.all

    if params[:keyword].present?
      knowledges = knowledges.where("title LIKE ?", "%#{params[:keyword]}%")
    end

    knowledges = if params[:page].present?
                   knowledges.page(params[:page]).per(30)
                 else
                   knowledges.page(1).per(30)
                 end

    totalPage = knowledges.total_pages

    render json: { knowledges:, totalPage: }, status: :ok
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
    ).merge(isBookmark: bookmark.present?,
            myProfile: current_api_v1_user.profile.as_json(include: {
                                                             user: { only: [:name], methods: :image_url }
                                                           })) }, status: :ok
  rescue ActiveRecord::RecordNotFound
    render json: { errors: "対象のデータが見つかりません" }, status: :not_found
  end

  def delete_image
    knowledge = Knowledge.find(params[:id])

    image = knowledge.images.find(params[:image_id])
    image.purge

    render json: { knowledge: knowledge.as_json(methods: :image_urls) }, status: :ok
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

  def get_target_user_knowledge
    knowledges = Knowledge.where(user_id: params[:user_id])

      # ユーザーページで表示するデータを取得する処理なので、最大5件分のみレスポンスとしてレンダリングする
    if knowledges.count > 5
      knowledges = knowledges.latest_knowledges(5)
    end

    render json: { knowledges: }, status: :ok
  end

  private

    def knowledge_register_params
      params.require(:knowledge).permit(:title, :content, :images)
    end
end
