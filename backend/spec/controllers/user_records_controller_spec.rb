require "rails_helper"

RSpec.describe Api::V1::UserRecordsController, type: :controller do
  let!(:user) { create(:user, :with_records, :without_knowledges) }
  let(:headers) { user.create_new_auth_token }
  let(:common_header) { {'X-Requested-With': 'XMLHttpRequest' } }

  def create_records(count)
    create_list(:record, count, user:)
  end

  describe "GET #index" do
    context "ユーザーのデータ5件あるパターン" do
      before do
        request.headers.merge!(headers)
        request.headers.merge!(common_header)
        get :index, params: { user_id: user.id }, format: :json
      end

      it "ステータス200" do
        expect(response.status).to eq 200
      end

      it "データは5件分取得" do
        json_response = JSON.parse(response.body)
        expect(json_response["records"].count).to eq 5
      end
    end

    context "対象のユーザーがいないパターン" do
      before do
        request.headers.merge!(headers)
        request.headers.merge!(common_header)
        get :index, params: { user_id: -1 }, format: :json
      end

      it "ステータス200" do
        expect(response.status).to eq 200
      end

      it "データは0件" do
        json_response = JSON.parse(response.body)
        expect(json_response["records"].count).to eq 0
      end
    end
      
    context "対象のユーザーがいないパターン" do
      before do
        request.headers.merge!(headers)
        request.headers.merge!(common_header)
        get :index, params: { user_id: -1 }, format: :json
      end
          
      it "ステータス200" do
        expect(response.status).to eq 200
      end
          
      it "データは0件" do
        json_response = JSON.parse(response.body)
        expect(json_response["records"].count).to eq 0
      end
    end

    describe "GET #index" do
      context "ユーザーのデータ7件あるパターン" do
        let(:user) { create(:user, :with_records_over, :without_knowledges) }

        before do
          request.headers.merge!(headers)
          request.headers.merge!(common_header)
          get :index, params: { user_id: user.id }, format: :json
        end

        it "ステータス200" do
          expect(response.status).to eq 200
        end

        it "データは5件分取得" do
          json_response = JSON.parse(response.body)
          expect(json_response["records"].count).to eq 5
        end
      end
    end

    describe "GET #show" do
      context "対象のユーザーを取得できるパターン" do
        let(:user) { create(:user, :with_records_over, :without_knowledges) }

        before do
          request.headers.merge!(headers)
          request.headers.merge!(common_header)
          get :index, params: { user_id: user.id }, format: :json
        end

        it "ステータス200" do
          expect(response.status).to eq 200
        end

        it "データは5件分取得" do
          json_response = JSON.parse(response.body)
          expect(json_response["records"].count).to eq 5
        end
      end
    end
  end
end
