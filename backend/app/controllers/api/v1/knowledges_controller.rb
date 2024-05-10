class Api::V1::KnowledgesController < ApplicationController
    before_action :set_user

    def index
        knowledges = Knowledge.all

        if params[:keyword].present? 
            knowledges = knowledges.where("title LIKE ?", "%#{params[:keyword]}%")
        end

        if params[:page].present?
            knowledges = knowledges.page(params[:page]).per(50)
        else
            knowledges = knowledges.page(1).per(50)
        end

        totalPage = knowledges.total_pages

        render json: { knowledges: knowledges, totalPage: totalPage }, status: 200
    end

    def create
        knowledge = @user.knowledges.build(knowledge_register_params)

        if knowledge.save
            render json: { knowledge: knowledge }, status: 200
        else
            render json: { errors: knowledge.errors.full_messages }, status: 422
        end
    end

    def show
        if params[:id].nil?
            return render json: { error: 'IDが不足しています'}, status: 400
        end

        begin
            knowledge = Knowledge.find(params[:id].to_i)
        rescue ActiveRecord::RecordNotFound
            return render json: { error: '対象のデータが見つかりません' }, status: 404
        end

        bookmark = knowledge.bookmarks.where(knowledge_id: knowledge.id).first
        render json: { knowledge: knowledge.as_json(include: [:comments], methods: :image_urls), isBookmark: bookmark.present? }, status: 200
    end

    def delete_image
        if params[:id].nil? && params[:image_id].nil?
            return render json: { error: 'IDが不足しています'}, status: 400
        end

        begin
            knowledge = Knowledge.find(params[:id].to_i)
        rescue ActiveRecord::RecordNotFound
            return render json: { error: '対象のデータが見つかりません' }, status: 404
        end

        image = knowledge.images.find(params[:image_id])
        image.purge

        render json: { knowledge: knowledge.as_json(methods: :image_urls) }, status: 200
    end

    def update
        if params[:id].nil?
            return render json: { error: 'IDが不足しています'}, status: 400
        end

        begin
            knowledge = @user.knowledges.find(params[:id].to_i)
        rescue ActiveRecord::RecordNotFound
            return render json: { error: '対象のデータが見つかりません' }, status: 404
        end

        if knowledge.update(knowledge_register_params) 
            render json: { knowledge: knowledge }, status: 200
        else
            render json: { errors: knowledge.errors.full_messages }, status: 422
        end
    end

    def destroy
        if params[:id].nil?
            return render json: { error: 'IDが不足しています'}, status: 400
        end

        begin
            knowledge = @user.knowledges.find(params[:id].to_i)
        rescue ActiveRecord::RecordNotFound
            return render json: { error: '対象のデータが見つかりません' }, status: 404
        end

        if knowledge.destroy
            render json: { knowledge: knowledge }, status: 200
        else
            render json: { errors: knowledges.errors.full_messages }, status: 422
        end
    end

    def get_target_user_knowledge
        if params[:user_id].nil?
            return render json: { error: 'IDが不足しています'}, status: 400
        end

        knowledges = Knowledge.where(user_id: params[:user_id])

        # ユーザーページで表示するデータを取得する処理なので、最大5件分のみレスポンスとしてレンダリングする
        if knowledges.count > 5
            knowledges = knowledges.limit(5).order(created_at: :desc)
        end

        render json: { knowledges: knowledges }, status: 200
    end

    private

    def set_user
        if api_v1_user_signed_in?
            @user = current_api_v1_user
        else
            return render json: { error: '未ログイン' }, status: 401
        end
    end

    def knowledge_register_params
        params.require(:knowledge).permit(:title, :content, :images)
    end
end