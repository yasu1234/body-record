class Api::V1::UserRecordsController < ApplicationController
  before_action :check_login

    # ユーザーページで表示する最大5件分の自分の記録を取得する
  def index
    records = Record.where(user_id: params[:user_id])
    # ユーザーページで自分以外のユーザーの場合は公開設定の記録のみ取得する
    if params[:user_id].to_i != current_api_v1_user.id
      records = records.open
    end

    if records.count > 5
      records = records.latest_records.limit_count(5)
      render json: { records: records.as_json(methods: :formatted_date), is_more: true }, status: :ok
    else
      records = records.latest_records
      render json: { records: records.as_json(methods: :formatted_date), is_more: false }, status: :ok
    end
  end
end
