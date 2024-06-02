class Api::V1::ContactsController < ApplicationController
    before_action :check_login, only: %i[index show update]

    def index        
        contacts = Contact.all.order(created_at: :desc)

        render json: { contacts: contacts }, status: 200
    end

    def show
        contact = Contact.find(params[:id].to_i)
        render json: { contact: contact }, status: 200
    rescue ActiveRecord::RecordNotFound
        return render json: { errors: '対象のデータが見つかりません' }, status: 404
    rescue StandardError => e
        render json: { errors: e.message }, status: 500
    end

    def create        
        contact = Contact.new(contact_register_params)
        if current_api_v1_user.present?
            contact.user_id = current_api_v1_user.id
        end

        render json: { errors: contact.errors.full_messages }, status: 422 and return if contact.invalid?

        contact.save!

        ContactMailer.complete.deliver_later

        render json: { contact: contact }, status: 200
    rescue StandardError => e
        render json: { errors: e.message }, status: 500
    end

    def update
        contact = Contact.find(params[:id].to_i)
        contact.update!(contact_register_params)

        render json: { contact: contact }, status: 200
    rescue ActiveRecord::RecordNotFound
        render json: { error: '対象のデータが見つかりません' }, status: 404
    rescue ActiveRecord::RecordInvalid => e
        render json: { errors: e.record.errors.full_messages }, status: 422
    rescue StandardError => e
        render json: { errors: e.message }, status: 500
    end

    private

    def contact_register_params
        params.permit(:content, :status)
    end
end
