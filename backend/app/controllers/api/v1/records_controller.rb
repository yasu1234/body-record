class Api::V1::RecordsController < ApplicationController
    def searchMyRecord
        @totalCount = 0

        if api_v1_user_signed_in?
            @user = current_api_v1_user
        else
        end
        @records = Record.where(user_id: @user.id)

        if params[:keyword].present? 
            @records = @records.where("memo LIKE ?", "%#{params[:keyword]}%")
        end

        if params[:startDate].present?
            @records = @records.where("date >= ?", params[:startDate])
        end

        if params[:endDate].present?
            @records = @records.where("date <= ?", params[:endDate])
        end

        if params[:page].present?
            @records = @records.page(params[:page]).per(50)
        else
            @records = @records.page(1).per(50)
        end

        @totalPage = @records.total_pages

        render json: { records: @records, totalPage: @totalPage }, status: 200
    end

    def index
        @totalCount = 0

        if api_v1_user_signed_in?
            @user = current_api_v1_user
        else
        end

        @records = Record.where(open_flg: true)

        if params[:keyword].present? 
            @records = @records.where("memo LIKE ?", "%#{params[:keyword]}%")
        end

        if params[:startDate].present?
            @records = @records.where("date >= ?", params[:startDate])
        end

        if params[:endDate].present?
            @records = @records.where("date <= ?", params[:endDate])
        end

        if params[:page].present?
            @records = @records.page(params[:page]).per(50)
        else
            @records = @records.page(1).per(50)
        end

        @totalPage = @records.total_pages

        render json: { records: @records, totalPage: @totalPage }, status: 200
    end

    def show
        @user = current_api_v1_user
        @record = Record.where(id: params[:id].to_i).first
        render json: { record: @record, imageUrls: @record.image_urls, isMyRecord: @record.user_id == @user.id }, status: 200
    end

    def create
        @user = current_api_v1_user
        @record = Record.new(record_register_params)
        @record.user_id = @user.id
        @record.save
        render json: { record: @record }, status: 200
    end

    def update
        @user = current_api_v1_user
        @record = Record.where(id: params[:id].to_i).first
        @record.update(record_register_params)
        render json: { record: @record }, status: 200
    end

    def destroy
        @record = Record.find(params[:id])
        @record.images.purge
        @record.destroy
        render json: { success: true }, status: 200
    end

    def delete_image
        @record = Record.find(params[:id])
        @image = @record.images.find(params[:image_id])
        @image.purge
        render json: { imageUrls: @knowledge.image_urls }, status: 200
    end

    def get_target_user_record
        @records = Record.where(user_id: params[:user_id])

        # ユーザーページで表示するデータを取得する処理なので、最大5件分のみレスポンスとしてレンダリングする
        if @records.count > 5
            @records = @records.order("date DESC").limit(5)
        end

        render json: { records: @records }, status: 200
    end

    def record_register_params
        params.permit(:memo, :date, :user_id, :images)
    end
end