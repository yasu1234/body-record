class Api::V1::RecordsController < ApplicationController
  before_action :check_login

  def searchMyRecord
    base_scope = Record.where(user_id: current_api_v1_user.id)
    records, total_pages = Record.search_and_paginate(params, base_scope)

    render json: { records: records.as_json(methods: :formatted_date), totalPage: total_pages }, status: :ok
  end

  def index
    base_scope = Record.where(open_status: 1)
    records, total_pages = Record.search_and_paginate(params, base_scope)

    render json: { records: records.as_json(methods: :formatted_date), totalPage: total_pages }, status: :ok
  end

    # 指定した年月1ヶ月分の記録を取得する
  def get_record_month
    user = User.find(params[:user_id])

    if params[:targetYear].nil? || params[:targetMonth].nil?
      return render json: { errors: "対象のデータが見つかりません" }, status: :not_found
    end

    records_with_empty_dates = Record.get_month_records(params[:targetYear].to_i, params[:targetMonth].to_i, user)

    render json: { records: records_with_empty_dates.as_json(methods: :graph_formatted_date) }, status: :ok
  rescue ActiveRecord::RecordNotFound
    render json: { error: "対象のデータが見つかりません" }, status: :not_found
  rescue StandardError => e
    render json: { errors: e.message }, status: :internal_server_error
  end

  def show
    record = Record.find(params[:id])

    render json: { record: record.as_json(
      include: {
        user: { only: [:name], methods: :image_url }
      }, methods: [:image_urls, :formatted_date, :calendar_date]
    ).merge(isMyRecord: record.user_id == current_api_v1_user.id,
            myProfile: current_api_v1_user.profile.as_json(
              include: {
                user: { only: [:name], methods: :image_url }
              }
            )) }, status: :ok
  rescue ActiveRecord::RecordNotFound
    render json: { error: "対象のデータが見つかりません" }, status: :not_found
  rescue StandardError => e
    render json: { errors: e.message }, status: :internal_server_error
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
    record.update!(record_register_params)
    render json: { record: }, status: :ok
  rescue ActiveRecord::RecordNotFound
    render json: { errors: "対象のデータが見つかりません" }, status: :not_found
  rescue ActiveRecord::RecordInvalid => e
    render json: { errors: e.record.errors.full_messages }, status: :unprocessable_entity
  end

  def destroy
    record = current_api_v1_user.records.find(params[:id])

    record.images.purge
    record.destroy!
    render json: { record: }, status: :ok
  rescue ActiveRecord::RecordNotFound
    render json: { errors: "対象のデータが見つかりません" }, status: :not_found
  rescue StandardError => e
    render json: { errors: e.message }, status: :internal_server_error
  end

  def delete_image
    record = current_api_v1_user.record.find(params[:id])
    image = record.images.find(params[:image_id])
    image.purge
    render json: { imageUrls: record.image_urls }, status: :ok
  end

    # ユーザーページで表示する最大5件分の自分の記録を取得する
  def get_target_user_record
    records = Record.where(user_id: params[:user_id])

    records = if records.count > 5
                records.latest_records(5)
              else
                records.latest_records(records.count)
              end

    render json: { records: records.as_json(methods: :formatted_date) }, status: :ok
  end

  private

    def record_register_params
      params.require(:record).permit(:memo, :date, :user_id, :weight, :fat_percentage, :open_status, images: [])
    end
end
