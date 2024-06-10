class Api::V1::UserRecordsController < ApplicationController
    before_action :check_login

    # ユーザーページで表示する最大5件分の自分の記録を取得する
    def index
        records = Record.where(user_id: params[:user_id])

        if records.count > 5
            records = records.latest_records(5)
            return render json: { records: records.as_json(methods: :formatted_date), is_more: true }, status: :ok
        else
            records = records.latest_records(records.count)
            return render json: { records: records.as_json(methods: :formatted_date), is_more: false }, status: :ok
        end
    end
end