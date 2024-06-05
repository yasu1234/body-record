class Api::V1::MyrecordsController < ApplicationController
    before_action :check_login

    def index
        base_scope = Record.where(user_id: current_api_v1_user.id)
        records, total_pages = Record.search_and_paginate(params, base_scope)
   
        render json: { records: records.as_json(methods: :formatted_date), totalPage: total_pages }, status: 200
    end

    # 指定した年月1ヶ月分の記録を取得する
    def get_record_month
        user = User.find(params[:user_id])

        records_with_empty_dates = Record.get_month_records(params[:targetYear].to_i, params[:targetMonth].to_i, user)

        render json: { records: records_with_empty_dates.as_json(methods: :graph_formatted_date)}, status: 200
    rescue ActiveRecord::RecordNotFound
        return render json: { error: '対象のデータが見つかりません' }, status: 404
    rescue StandardError => e
        render json: { errors: e.message }, status: 500
    end

    def create
        record = current_api_v1_user.records.build(record_register_params)

        render json: { errors: record.errors.full_messages }, status: 422 and return if record.invalid?

        record.save!
        render json: { record: record }, status: 200
    rescue StandardError => e
        render json: { errors: e.message }, status: 500
    end

    def update        
        record = current_api_v1_user.records.find(params[:id])
        record.update!(record_register_params)

        render json: { record: record }, status: 200
    rescue ActiveRecord::RecordNotFound
        render json: { errors: '対象のデータが見つかりません' }, status: 404
    rescue ActiveRecord::RecordInvalid => e
        render json: { errors: e.record.errors.full_messages }, status: 422
    rescue StandardError => e
        render json: { errors: e.message }, status: 500
    end

    def destroy
        record = current_api_v1_user.records.find(params[:id])
        record.images.purge

        record.destroy!
    
        render json: { record: record }, status: 200
    rescue ActiveRecord::RecordNotFound
        render json: { errors: '対象のデータが見つかりません' }, status: 404
    rescue StandardError => e
        render json: { errors: e.message }, status: 500
    end

    def delete_image
        record = current_api_v1_user.record.find(params[:id])
        image = record.images.find(params[:image_id])
        image.purge
        render json: { imageUrls: record.image_urls }, status: 200
    end

    # ユーザーページで表示する最大5件分の自分の記録を取得する
    def get_target_user_record
        records = Record.where(user_id: params[:user_id])

        if records.count > 5
            records = records.latest_records(5)
        else
            records = records.latest_records(records.count)
        end

        render json: { records: records.as_json(methods: :formatted_date) }, status: 200
    end

    private

    def record_register_params
        params.require(:record).permit(:memo, :date, :user_id, :images, :weight, :fat_percentage, :open_status)
    end
end
