class Api::V1::KnowledgeImagesController < ApplicationController
    before_action :check_login

    def destroy        
        knowledge = Knowledge.find(params[:id])
        image = knowledge.images.find(params[:image_id])
        image.purge

        render json: { knowledge: knowledge.as_json(methods: :image_urls) }, status: 200
    rescue ActiveRecord::RecordNotFound
        render json: { errors: '対象のデータが見つかりません' }, status: 404
    end
end
