class Api::V1::RecordsController < ApplicationController
  before_action :check_login

  def index
    if params[:user_id].nil?
      render json: { errors: "ユーザー情報が特定できません" }, status: :bad_request and return 
    end

    base_scope = Record.where(open_status: 1).where(user_id: params[:user_id])
    records, total_pages = Record.search_and_paginate(params, base_scope)

    render json: { records: records.as_json(methods: :formatted_date), totalPage: total_pages }, status: :ok
  rescue ActiveRecord::RecordNotFound
    render json: { error: "対象のデータが見つかりません" }, status: :not_found
  rescue StandardError => e
    render json: { errors: e.message }, status: :internal_server_error
  end
  
  def show
    record = Record.find(params[:id])
  
    render json: {
      record: record.as_json(
        include: {
          user: { only: [:name], methods: :image_url }
        },
        methods: [:image_urls, :formatted_date, :calendar_date]
      ).merge(
        is_my_record: record.user_id == current_api_v1_user.id,
        is_open: record.open_status == 1,
        myProfile: current_api_v1_user.profile.as_json(
          include: {
            user: { only: [:name], methods: :image_url }
          }
        )
      )
    }, status: :ok
  rescue ActiveRecord::RecordNotFound
    render json: { error: "対象のデータが見つかりません" }, status: :not_found
  rescue StandardError => e
    render json: { errors: e.message }, status: :internal_server_error
  end

  def destroy
    record = current_api_v1_user.records.find(params[:id])
    record.images.purge

    record.destroy!
    
    render json: { record: record }, status: :ok
  rescue ActiveRecord::RecordNotFound
      render json: { errors: '対象のデータが見つかりません' }, status: :not_found
  rescue StandardError => e
      render json: { errors: e.message }, status: :internal_server_error
  end

  private

    def record_register_params
      params.require(:record).permit(:memo, :date, :user_id, :weight, :fat_percentage, :open_status, images: [])
    end
end
