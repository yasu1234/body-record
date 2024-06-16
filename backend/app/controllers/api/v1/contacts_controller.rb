class Api::V1::ContactsController < ApplicationController
  before_action :check_login, only: %i[show update]

  def index
    contacts = Contact.all.order(created_at: :desc)

    render json: { contacts: contacts }, status: :ok
  end

  def show
    contact = Contact.find(params[:id])
    render json: { contact: contact }, status: :ok
  rescue ActiveRecord::RecordNotFound
    render json: { errors: "対象のデータが見つかりません" }, status: :not_found
  rescue StandardError => e
    render json: { errors: e.message }, status: :internal_server_error
  end

  def create
    contact = Contact.new(contact_register_params)
    if current_api_v1_user.present?
      contact.user_id = current_api_v1_user.id
    end

    render json: { errors: contact.errors.full_messages }, status: :unprocessable_entity and return if contact.invalid?

    contact.save!

    ContactMailer.complete.deliver_later

    render json: { contact: contact }, status: :ok
  rescue StandardError => e
    render json: { errors: e.message }, status: :internal_server_error
  end

  def update
    contact = Contact.find(params[:id])
    contact.update!(contact_register_params)

    render json: { contact: contact }, status: :ok
  rescue ActiveRecord::RecordNotFound
    render json: { error: "対象のデータが見つかりません" }, status: :not_found
  rescue ActiveRecord::RecordInvalid => e
    render json: { errors: e.record.errors.full_messages }, status: :unprocessable_entity
  rescue StandardError => e
    render json: { errors: e.message }, status: :internal_server_error
  end

  private

    def contact_register_params
      params.require(:contact).permit(:content, :status)
    end
end
