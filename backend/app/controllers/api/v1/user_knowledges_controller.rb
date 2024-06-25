class Api::V1::UserKnowledgesController < ApplicationController
  before_action :check_login

  def index
    knowledges = Knowledge.where(user_id: params[:user_id]).latest_knowledges
      # ユーザーページで表示するデータを取得する処理なので、最大5件分のみレスポンスとしてレンダリングする
    limited_knowledges = knowledges.take(5)
    is_more = knowledges.count > 5

    render json: { 
      knowledges: limited_knowledges.as_json(
        include: {
          user: { only: [:name], methods: :image_url }
        },
        methods: :create_date_format
      ), is_more:
    }, status: :ok
  end
end
