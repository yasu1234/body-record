class Api::V1::KnowledgesController < ApplicationController
    before_action :check_login

    def index
        knowledges = Knowledge.all

        if params[:keyword].present? 
            knowledges = knowledges.where("title LIKE ?", "%#{params[:keyword]}%")
        end

        if params[:page].present?
            knowledges = knowledges.page(params[:page]).per(30)
        else
            knowledges = knowledges.page(1).per(30)
        end

        totalPage = knowledges.total_pages

        render json: { knowledges: knowledges, totalPage: totalPage }, status: 200
    end

    def create
        knowledge = current_api_v1_user.knowledges.build(knowledge_register_params)

        render json: { errors: knowledge.errors.full_messages }, status: 422 and return if knowledge.invalid?

        knowledge.save!
        render json: { knowledge: knowledge }, status: 200
    rescue StandardError => e
        render json: { errors: e.message }, status: 500
    end

    def show
        if params[:id].nil?
            return render json: { errors: 'IDが不足しています'}, status: 400
        end

        knowledge = Knowledge.find(params[:id].to_i)
        bookmark = knowledge.bookmarks.where(knowledge_id: knowledge.id).first
        render json: { knowledge: knowledge.as_json(
            include: {
                user: {only: [:name], methods: :image_url}
            }, methods: :image_urls).merge(isBookmark: bookmark.present?,
            myProfile: current_api_v1_user.profile.as_json(include: {
                user: {only: [:name], methods: :image_url}})) }, status: 200
    rescue ActiveRecord::RecordNotFound
        render json: { errors: '対象のデータが見つかりません' }, status: 404        
    end

    def delete_image        
        knowledge = Knowledge.find(params[:id].to_i)
        image = knowledge.images.find(params[:image_id])
        image.purge

        render json: { knowledge: knowledge.as_json(methods: :image_urls) }, status: 200
    rescue ActiveRecord::RecordNotFound
        render json: { errors: '対象のデータが見つかりません' }, status: 404
    end

    def update
        if params[:id].nil?
            return render json: { errors: 'IDが不足しています'}, status: 400
        end

        knowledge = current_api_v1_user.knowledges.find(params[:id].to_i)
        knowledge.update(knowledge_register_params)

        render json: { errors: knowledge.errors.full_messages }, status: 422 and return if knowledge.invalid?

        knowledge.save!
        render json: { knowledge: knowledge }, status: 200
    rescue ActiveRecord::RecordNotFound
        render json: { errors: '対象のデータが見つかりません' }, status: 404
    rescue StandardError => e
        render json: { errors: e.message }, status: 500
    end

    def destroy
        knowledge = current_api_v1_user.knowledges.find(params[:id].to_i)
        knowledge.destroy!

        render json: { knowledge: knowledge }, status: 200
    rescue ActiveRecord::RecordNotFound
        render json: { errors: '対象のデータが見つかりません' }, status: 404
    rescue StandardError => e
        render json: { errors: e.message }, status: 500
    end

    def get_target_user_knowledge
        knowledges = Knowledge.where(user_id: params[:user_id])

        # ユーザーページで表示するデータを取得する処理なので、最大5件分のみレスポンスとしてレンダリングする
        if knowledges.count > 5
            knowledges = knowledges.latest_knowledges(5)
        end

        render json: { knowledges: knowledges }, status: 200
    end

    private

    def knowledge_register_params
        params.require(:knowledge).permit(:title, :content, :images)
    end
end