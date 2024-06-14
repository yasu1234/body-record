class Api::V1::RecordImagesController < ApplicationController
    before_action :check_login

    def destroy
      record = current_api_v1_user.records.find(params[:id])
      image = record.images.find(params[:image_id])
      image.purge
      render json: { imageUrls: record.image_urls }, status: :ok
    rescue ActiveRecord::RecordNotFound
      render json: { errors: '対象のデータが見つかりません' }, status: :not_found
    rescue StandardError => e
      render json: { errors: e.message }, status: :internal_server_error
    end
end
