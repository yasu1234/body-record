class Api::V1::RecordImagesController < ApplicationController
    before_action :check_login

    def destroy
        record = current_api_v1_user.record.find(params[:id])
        image = record.images.find(params[:image_id])
        image.purge
        render json: { imageUrls: record.image_urls }, status: 200
    end
end
