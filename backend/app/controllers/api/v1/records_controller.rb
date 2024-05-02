class Api::V1::RecordsController < ApplicationController
    before_action :set_user

    def searchMyRecord
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

    def get_record_month
        if params[:user_id].nil? && params[:targetYear].nil? && params[:targetMonth].nil?
            return render json: { error: '必須項目が不足しています'}, status: 400
        end

        records = Record.where(user_id: params[:user_id])

        start_date = DateTime.new(params[:targetYear].to_i, params[:targetMonth].to_i, 1)
        end_date = start_date.next_month
     
        # 1ヶ月全ての日付を含む配列を作成
        dates = []
        current_date = start_date
        while current_date < end_date
            dates << current_date
            current_date = current_date.next_day
        end

        records = Record.where(date: start_date..end_date)

        # 1ヶ月全ての日付で体重や体脂肪率が存在しない場合は、0で埋める
        records_with_empty_dates = dates.map do |date|
            record = records.find { |r| r.date == date }
            if record
                record
            else
                Record.new(date: date, weight: 0)
            end
        end

        render json: { record: records_with_empty_dates.as_json(methods: :set_formatted_date)}, status: 200
    end

    def show
        if params[:id].nil?
            return render json: { error: 'IDが不足しています'}, status: 400
        end

        @record = Record.where(id: params[:id].to_i).first
        render json: { record: @record, imageUrls: @record.image_urls, isMyRecord: @record.user_id == @user.id }, status: 200
    end

    def create
        @record = Record.new(record_register_params)
        @record.user_id = @user.id
        if @record.save
            render json: { record: @record }, status: 200
        else
            render json: { errors: @record.errors }, status: 422
        end
    end

    def update
        if params[:id].nil?
            return render json: { error: 'IDが不足しています'}, status: 400
        end

        @record = Record.where(id: params[:id].to_i).first
        if @record.update(record_register_params)
            render json: { record: @record }, status: 200
        else
            render json: { errors: @record.errors }, status: 422
        end
    end

    def destroy
        if params[:id].nil?
            return render json: { error: 'IDが不足しています'}, status: 400
        end

        @record = Record.find(params[:id])
        @record.images.purge
        if @record.destroy
            render json: { success: true }, status: 200
        else
            render json: { errors: @record.errors }, status: 422
        end
    end

    def delete_image
        @record = Record.find(params[:id])
        @image = @record.images.find(params[:image_id])
        @image.purge
        render json: { imageUrls: @knowledge.image_urls }, status: 200
    end

    def get_target_user_record
        if params[:user_id].nil?
            return render json: { error: 'ユーザーIDが不足しています'}, status: 400
        end
        @records = Record.where(user_id: params[:user_id])

        # ユーザーページで表示するデータを取得する処理なので、最大5件分のみレスポンスとしてレンダリングする
        if @records.count > 5
            @records = @records.order("date DESC").limit(5)
        end

        render json: { records: @records }, status: 200
    end

    private

    def set_user
        if api_v1_user_signed_in?
            @user = current_api_v1_user
        else
            render json: { errors: "未ログイン" ,status: 401 }
        end
    end

    def record_register_params
        params.permit(:memo, :date, :user_id, :images, :weight, :fat_percentage)
    end
end