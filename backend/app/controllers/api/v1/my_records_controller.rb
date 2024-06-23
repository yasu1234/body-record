class Api::V1::MyRecordsController < ApplicationController
  before_action :check_login

  def index
    base_scope = Record.where(user_id: current_api_v1_user.id)
    if params[:is_only_open].present? && params[:is_only_open] == "true"
      base_scope = base_scope.where(open_status: 1)
    end

    records, total_pages = Record.search_and_paginate(params, base_scope)

    render json: { records: records.as_json(methods: :formatted_date), totalPage: total_pages }, status: :ok
  end

  def create
    record = current_api_v1_user.records.build(record_register_params)

    render json: { errors: record.errors.full_messages }, status: :unprocessable_entity and return if record.invalid?

    record.save!
    render json: { record: }, status: :ok
  rescue StandardError => e
    render json: { errors: e.message }, status: :internal_server_error
  end

  def update
    record = current_api_v1_user.records.find(params[:id])

    # 画像がある場合は既存の画像は残したまま追加
    if params[:record][:images].present?
      new_images = params[:record][:images]
      record.images.attach(new_images)
      params[:record].delete(:images)
    end

    record.update!(record_register_params)

    render json: { record: }, status: :ok
  rescue ActiveRecord::RecordNotFound
    render json: { errors: "対象のデータが見つかりません" }, status: :not_found
  rescue ActiveRecord::RecordInvalid => e
    render json: { errors: e.record.errors.full_messages }, status: :unprocessable_entity
  rescue StandardError => e
    render json: { errors: e.message }, status: :internal_server_error
  end

  private

    def record_register_params
      params.require(:record).permit(:memo, :date, :user_id, :weight, :fat_percentage, :open_status, images: [])
    end
end
