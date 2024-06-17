require "rails_helper"

RSpec.describe Api::V1::UserKnowledgesController, type: :controller do
  let!(:user) { create(:user, :with_knowledges, :without_records) }
  let(:headers) { user.create_new_auth_token }
  let(:common_header) { {'X-Requested-With': 'XMLHttpRequest' } }
  let(:image) { file_fixture("image.png") }

  def create_knowledges(count)
    create_list(:knowledge, count, user:)
  end

  describe "GET #index" do
    context "ユーザーのデータ5件" do
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
        expect(json_response["knowledges"].count).to eq 5
      end
    end

    describe "GET #index" do
      context "成功(対象のユーザーがいない)" do
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
          expect(json_response["knowledges"].count).to eq 0
        end
      end
    end

    describe "GET #index" do
      context "ユーザーのデータ7件" do
        let(:user) { create(:user, :with_knowledges_over, :without_records) }

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
          expect(json_response["knowledges"].count).to eq 5
        end
      end
    end
  end
end
