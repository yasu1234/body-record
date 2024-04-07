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

        @totalCount = @records.count

        render json: { records: @records, totalCount: @totalCount }, status: 200
    end
end