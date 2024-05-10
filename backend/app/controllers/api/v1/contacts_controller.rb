class Api::V1::ContactsController < ApplicationController
    def index
        return render json: { error: '未ログイン' }, status: 401 unless api_v1_user_signed_in?
        
        contacts = Contact.all.order(created_at: :desc)

        render json: { contacts: contacts }, status: 200
    end

    def show
        return render json: { error: '未ログイン' }, status: 401 unless api_v1_user_signed_in?

        if params[:id].present?
            begin
                contact = Contact.find(params[:id].to_i)
            rescue ActiveRecord::RecordNotFound
                return render json: { error: '対象のデータが見つかりません' }, status: 404
            end
        else
            return render json: { errors: "対象の問い合わせデータがありません" }, status: 404
        end

        render json: { contact: contact }, status: 200
    end

    def create
        user = current_api_v1_user
        
        contact = Contact.new(contact_register_params)
        if user.present?
            contact.user_id = user.id
        end

        if contact.save
            ContactMailer.complete.deliver_later
            render json: { contact: contact }, status: 200
        else
            render json: { errors: contact.errors.full_messages }, status: 422
        end
    end

    def update
        return render json: { error: '未ログイン' }, status: 401 unless api_v1_user_signed_in?

        if params[:id].present?
            begin
                contact = Contact.find(params[:id].to_i)
            rescue ActiveRecord::RecordNotFound
                return render json: { error: '対象のデータが見つかりません' }, status: 404
            end
        else
            return render json: { errors: "対象の問い合わせデータがありません" }, status: 404
        end

        if contact.update(contact_register_params)
            render json: { contact: contact }, status: 200
        else
            render json: { errors: contact.errors.to_hash(true) }, status: 422
        end
    end

    private

    def contact_register_params
        params.permit(:content, :status)
    end
end