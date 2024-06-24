require "rails_helper"

RSpec.describe Api::V1::SupportsController, type: :controller do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:headers) { user.create_new_auth_token }
  let(:common_header) { { 'X-Requested-With': "XMLHttpRequest" } }

  describe "POST #create" do
    context "未ログイン" do
      before do
        request.headers.merge!(common_header)
        post :create, format: :json, params: { id: other_user.id }
      end

      it "ステータス401が返却される" do
        expect(response.status).to eq 401
      end
    end

    context "既に応援済の場合" do
      let(:user) { create(:user, :fixed_id, :with_supporting) }

      before do
        request.headers.merge!(headers)
        request.headers.merge!(common_header)
        post :create, format: :json, params: { id: other_user.id }
      end

      it "ステータス200が返却される" do
        expect(response.status).to eq 200
      end

      it "パラメータで指定したユーザーを応援している" do
        json_response = JSON.parse(response.body)
        expect(json_response["user"]["id"]).to eq other_user.id
        expect(json_response["user"]["supporter_count"]).to eq 1
        expect(json_response["user"]["support_count"]).to eq 0
        expect(json_response["user"]["is_support"]).to eq true
      end
    end

    context "応援登録完了" do
      let(:user) { create(:user, :fixed_id) }

      before do
        request.headers.merge!(headers)
        request.headers.merge!(common_header)
        post :create, format: :json, params: { id: other_user.id }
      end

      it "ステータス200が返却される" do
        expect(response.status).to eq 200
      end

      it "応援データが取得できる" do
        json_response = JSON.parse(response.body)
        expect(json_response["user"]["id"]).to eq other_user.id
        expect(json_response["user"]["supporter_count"]).to eq 1
        expect(json_response["user"]["support_count"]).to eq 0
        expect(json_response["user"]["is_support"]).to eq true
      end
    end
  end

  describe "DELETE #destroy" do
    context "未ログイン" do
      before do
        request.headers.merge!(common_header)
        delete :destroy, format: :json, params: { id: other_user.id }
      end

      it "ステータス401が返却される" do
        expect(response.status).to eq 401
      end
    end

    context "応援解除" do
      let(:user) { create(:user, :with_supporting) }

      before do
        request.headers.merge!(headers)
        request.headers.merge!(common_header)
        delete :destroy, format: :json, params: { id: user.supportings.first.id }
      end

      it "ステータス200が返却される" do
        expect(response.status).to eq 200
      end

      it "応援データが取得できる" do
        json_response = JSON.parse(response.body)
        expect(json_response["user"]["supporter_count"]).to eq 0
        expect(json_response["user"]["is_support"]).to eq false
      end
    end

    context "応援解除(既に削除済み)" do
      let(:user) { create(:user, :with_supporting) }

      before do
        request.headers.merge!(headers)
        request.headers.merge!(common_header)
        delete :destroy, format: :json, params: { id: other_user.id }
      end

      it "ステータス422が返却される" do
        expect(response.status).to eq 422
      end
    end
  end
end
