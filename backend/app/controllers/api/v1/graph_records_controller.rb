class Api::V1::GraphRecordsController < ApplicationController
    before_action :check_login

    # 指定した年月1ヶ月分の記録を取得する
    def index
        user = User.find(params[:user_id])

        records_with_empty_dates = Record.get_month_records(params[:targetYear].to_i, params[:targetMonth].to_i, user)

        render json: { records: records_with_empty_dates.as_json(methods: :graph_formatted_date)}, status: 200
    rescue ActiveRecord::RecordNotFound
        return render json: { error: '対象のデータが見つかりません' }, status: 404
    rescue StandardError => e
        render json: { errors: e.message }, status: 500
    end
end
