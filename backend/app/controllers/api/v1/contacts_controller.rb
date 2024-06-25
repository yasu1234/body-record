class Api::V1::ContactsController < ApplicationController
  before_action :check_login, only: %i[show update]

  def index
    contacts = Contact.all.order(created_at: :desc)

    render json: {
      contacts: contacts.map do |contact|
        contact.as_json(methods: :contact_date_format)
      end
    }, status: :ok
  end

  def show
    contact = Contact.find(params[:id])
    render json: { contact: contact.as_json(methods: :contact_date_format) }, status: :ok
  rescue ActiveRecord::RecordNotFound
    render json: { errors: "対象のデータが見つかりません" }, status: :not_found
  end

  def create
    contact = Contact.new(contact_register_params)
    if current_api_v1_user.present?
      contact.user_id = current_api_v1_user.id
    end

    render json: { errors: contact.errors.full_messages }, status: :unprocessable_entity and return if contact.invalid?

    contact.save!

    ContactMailer.complete.deliver_later

    render json: { contact: contact.as_json(methods: :contact_date_format) }, status: :ok
  end

  def update
    contact = Contact.find(params[:id])
    contact.update!(contact_register_params)

    render json: { contact: contact.as_json(methods: :contact_date_format) }, status: :ok
  rescue ActiveRecord::RecordNotFound
    render json: { error: "対象のデータが見つかりません" }, status: :not_found
  rescue ActiveRecord::RecordInvalid => e
    render json: { errors: e.record.errors.full_messages }, status: :unprocessable_entity
  end

  private

    def contact_register_params
      params.require(:contact).permit(:content, :status)
    end
end
