class Api::V1::RecordsController < ApplicationController
    before_action :check_login

    def index
        base_scope = Record.where(open_status: 1)
        records, total_pages = Record.search_and_paginate(params, base_scope)

        render json: { records: records.as_json(methods: :formatted_date), totalPage: total_pages }, status: 200
    end

    def show
        record = Record.find(params[:id])
        render json: { record: record.as_json(
            include: {
                user: {only: [:name], methods: :image_url}
            }, methods: :image_urls).merge(isMyRecord: record.user_id == current_api_v1_user.id,
             myProfile: current_api_v1_user.profile.as_json(
                include: {
                    user: {only: [:name], methods: :image_url}
                })) }, status: 200
    rescue ActiveRecord::RecordNotFound
        return render json: { error: '対象のデータが見つかりません' }, status: 404
    rescue StandardError => e
        render json: { errors: e.message }, status: 500
    end

    def delete_image
        record = current_api_v1_user.record.find(params[:id])
        image = record.images.find(params[:image_id])
        image.purge
        render json: { imageUrls: record.image_urls }, status: 200
    end

    private

    def record_register_params
        params.require(:record).permit(:memo, :date, :user_id, :images, :weight, :fat_percentage, :open_status)
    end
end
