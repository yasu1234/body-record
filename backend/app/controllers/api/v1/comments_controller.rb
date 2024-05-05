class Api::V1::CommentsController < ApplicationController
    before_action :check_user

    def create_knowledge_comment
        if knowledge_comment_params[:knowledge_id].nil?
            return render json: { error: 'IDが不足しています'}, status: 400
        end

        begin
            knowledge = Knowledge.find(knowledge_comment_params[:knowledge_id].to_i)
        rescue ActiveRecord::RecordNotFound
            return render json: { error: '対象のデータが見つかりません' }, status: 404
        end

        comment = knowledge.comments.build(knowledge_comment_params)
        comment.user_id = @user.id

        if comment.save
            render json: { knowledge: knowledge.as_json(include: [:comments])}, status: 200
        else
            render json: { error: comment.errors.to_hash(true)}, status: 422
        end
    end

    def create_record_comment
        if record_comment_params[:record_id].nil? 
            return render json: { error: 'IDが不足しています'}, status: 400
        end

        begin
            record = Record.find(record_comment_params[:record_id].to_i)
        rescue ActiveRecord::RecordNotFound
            return render json: { error: '対象のデータが見つかりません' }, status: 404
        end

        comment = record.comments.build(record_comment_params)
        comment.user_id = @user.id

        if @comment.save
            render json: { record: record.as_json(include: [:comments]) }, status: 200
        else
            render json: { error: comment.errors.to_hash(true)}, status: 422
        end
    end

    def destroy
    end

    def knowledge_comment_params
        params.permit(:knowledge_id, :comment)
    end

    def record_comment_params
        params.permit(:record_id, :comment)
    end

    private 

    def check_user
        if api_v1_user_signed_in?
            @user = current_api_v1_user
        else
            render json: { error: '未ログイン'}, status: 400
        end
    end
end