class Api::V1::CommentsController < ApplicationController
    before_action :check_login

    def get_knowledge_comment
        if params[:knowledge_id].nil?
            return render json: { error: 'IDが不足しています'}, status: 400
        end

        begin
            comments = Comment.where(knowledge_id: params[:knowledge_id])
        rescue ActiveRecord::RecordNotFound
            return render json: { error: '対象のデータが見つかりません' }, status: 404
        end

        render json: { comments: comments.as_json(include: { user: { only: [:name], methods: :image_url } })}, status: 200
    end

    def get_record_comment
        if params[:record_id].nil?
            return render json: { error: 'IDが不足しています'}, status: 400
        end

        begin
            comments = Comment.where(record_id: params[:record_id])
        rescue ActiveRecord::RecordNotFound
            return render json: { error: '対象のデータが見つかりません' }, status: 404
        end

        render json: { comments: comments.as_json(include: { user: { only: [:name], methods: :image_url } })}, status: 200
    end

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
        comment.user_id = current_api_v1_user.id

        if comment.save
            render json: { comments: knowledge.comments.as_json(include: { user: { only: [:name], methods: :image_url } })}, status: 200
        else
            render json: { errors: comment.errors.full_messages}, status: 422
        end
    end

    def create_record_comment
        if record_comment_params[:record_id].nil? 
            return render json: { errors: 'IDが不足しています'}, status: 400
        end

        begin
            record = Record.find(record_comment_params[:record_id].to_i)
        rescue ActiveRecord::RecordNotFound
            return render json: { errors: '対象のデータが見つかりません' }, status: 404
        end

        comment = record.comments.build(record_comment_params)
        comment.user_id = current_api_v1_user.id

        if @comment.save
            render json: { record: record.as_json(include: [:comments]) }, status: 200
        else
            render json: { errors: comment.errors.full_messages}, status: 422
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
end