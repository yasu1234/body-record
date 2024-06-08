class Api::V1::MyRecordsController < ApplicationController
    before_action :check_login

    def index
        base_scope = Record.where(user_id: current_api_v1_user.id)
        records, total_pages = Record.search_and_paginate(params, base_scope)
   
        render json: { records: records.as_json(methods: :formatted_date), totalPage: total_pages }, status: 200
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

    private

    def record_register_params
        params.require(:record).permit(:memo, :date, :user_id, :images, :weight, :fat_percentage, :open_status)
    end
end
