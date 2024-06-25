class Api::V1::KnowledgeImagesController < ApplicationController
  before_action :check_login

  def destroy
    knowledge = Knowledge.find(params[:id])

    image = knowledge.images.find(params[:image_id])
    image.purge

    render json: { image_urls: knowledge.image_urls }, status: :ok
  rescue ActiveRecord::RecordNotFound
    render json: { errors: "対象のデータが見つかりません" }, status: :not_found
  end
end
