class Api::V1::RecordsController < ApplicationController
    before_action :set_user

    def searchMyRecord
        base_scope = Record.where(user_id: @user.id)
        records, total_pages = search_and_paginate_records(base_scope)
   
        render json: { records: records.as_json(methods: :formatted_date), totalPage: total_pages }, status: 200
    end

    def index
        base_scope = Record.where(open_status: 1)
        records, total_pages = search_and_paginate_records(base_scope)

        render json: { records: records.as_json(methods: :formatted_date), totalPage: total_pages }, status: 200
    end

    # 指定した年月1ヶ月分の記録を取得する
    def get_record_month
        if params[:user_id].nil? || params[:targetYear].nil? || params[:targetMonth].nil?
            return render json: { error: '必須項目が不足しています'}, status: 422
        end

        user = User.find(params[:user_id])

        start_date = DateTime.new(params[:targetYear].to_i, params[:targetMonth].to_i, 1)
        end_date = start_date.next_month
     
        # 1ヶ月全ての日付を含む配列を作成
        dates = []
        current_date = start_date
        while current_date < end_date
            dates << current_date
            current_date = current_date.next_day
        end

        records = user.records.where(date: start_date..end_date)

        records_with_empty_dates = records.records_in_month(dates)

        render json: { records: records_with_empty_dates.as_json(methods: :graph_formatted_date)}, status: 200
    end

    def show
        if params[:id].nil?
            return render json: { errors: 'IDが不足しています'}, status: 404
        end

        begin
            record = Record.find(params[:id].to_i)
        rescue ActiveRecord::RecordNotFound
            return render json: { error: '対象のデータが見つかりません' }, status: 404
        end

        render json: { record: record.as_json(
            include: {
                user: {only: [:name], methods: :image_url}
            }, methods: :image_urls).merge(isMyRecord: record.user_id == @user.id,
             myProfile: @user.profile.as_json(
                include: {
                    user: {only: [:name], methods: :image_url}
                })) }, status: 200
    end

    def create
        record = @user.records.build(record_register_params)

        if record.save
            render json: { record: record }, status: 200
        else
            render json: { errors: record.errors.full_messages }, status: 422
        end
    end

    def update
        if params[:id].nil?
            return render json: { errors: 'IDが不足しています'}, status: 404
        end

        begin
            record = @user.records.find(params[:id].to_i)
        rescue ActiveRecord::RecordNotFound
            return render json: { errors: '対象のデータが見つかりません' }, status: 404
        end

        if record.update(record_register_params)
            render json: { record: record }, status: 200
        else
            render json: { errors: record.errors.full_messages }, status: 422
        end
    end

    def destroy
        if params[:id].nil?
            return render json: { errors: 'IDが不足しています'}, status: 404
        end

        begin
            record = @user.records.find(params[:id].to_i)
        rescue ActiveRecord::RecordNotFound
            return render json: { errors: '対象のデータが見つかりません' }, status: 404
        end

        record.images.purge
        if record.destroy
            render json: { record: record }, status: 200
        else
            render json: { errors: record.errors.full_message }, status: 422
        end
    end

    def delete_image
        record = @user.record.find(params[:id])
        image = record.images.find(params[:image_id])
        image.purge
        render json: { imageUrls: record.image_urls }, status: 200
    end

    # ユーザーページで表示する最大5件分の自分の記録を取得する
    def get_target_user_record
        records = Record.where(user_id: params[:user_id])

        if records.count > 5
            records = records.latest_records(5)
        else
            records = records.latest_records(records.count)
        end

        render json: { records: records.as_json(methods: :formatted_date) }, status: 200
    end

    private

    def set_user
        if api_v1_user_signed_in?
            @user = current_api_v1_user
        else
            render json: { errors: "未ログイン" }, status: 401
        end
    end
    
    def search_and_paginate_records(base_scope)
        records = base_scope
        
        if params[:keyword].present?
            records = records.where("lower(memo) LIKE :keyword", keyword: "%#{params[:keyword]}%")
        end
        
        if params[:startDate].present?
            records = records.where("date >= ?", params[:startDate])
        end
        
        if params[:endDate].present?
            records = records.where("date <= ?", params[:endDate])
        end
        
        if params[:page].present?
            records = records.page(params[:page]).per(30)
        else
            records = records.page(1).per(30)
        end
        
        [records, records.total_pages]
    end

    def record_register_params
        params.require(:record).permit(:memo, :date, :user_id, :images, :weight, :fat_percentage, :open_status)
    end
end