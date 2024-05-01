class Api::V1::ContactsController < ApplicationController
    def index
        if api_v1_user_signed_in?
            user = current_api_v1_user
        else
        end
        
        contacts = Contact.all.order(created_at: :desc)

        render json: { contacts: contacts }, status: 200
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

    def contact_register_params
        params.permit(:content)
    end
end