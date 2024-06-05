class Api::V1::UserKnowledgesController < ApplicationController
    before_action :check_login

    def index
        knowledges = Knowledge.where(user_id: params[:user_id])

        # ユーザーページで表示するデータを取得する処理なので、最大5件分のみレスポンスとしてレンダリングする
        if knowledges.count > 5
            knowledges = knowledges.latest_knowledges(5)
        end

        render json: { knowledges: knowledges }, status: 200
    end
end
