require "rails_helper"

RSpec.describe Api::V1::MyRecordsController, type: :controller do
  let!(:user) { create(:user, :with_records, :without_knowledges) }
  let(:headers) { user.create_new_auth_token }
  let(:common_header) { {'X-Requested-With': 'XMLHttpRequest' } }
  let(:image) { file_fixture("image.png") }
  let(:valid_params) { { memo: "メモTEST", date: "2024-04-29", 'images[]': [image] } }
  let(:invalid_params) { { memo: "", content: "テストコンテンツ", user_id: user.id } }
  let(:update_valid_params) { { memo: "メモ更新TEST", date: "2024-04-01", 'images[]': [image] } }

  def create_records(count)
    create_list(:record, count, user:)
  end

  describe "POST #create" do
    context "未ログイン" do
      before do
        request.headers.merge!(common_header)
        post :create, format: :json, params: valid_params
      end

      it "401(未認証のステータスコード)" do
        expect(response.status).to eq 401
      end
    end
  end

  describe "POST #create" do
    context "作成完了" do
      before do
        request.headers.merge!(headers)
        request.headers.merge!(common_header)
        post :create, format: :json, params: { record: valid_params }
      end

      it "1件データが追加" do
        expect(change(Record, :count).by(1))
        expect(response.status).to eq 200
      end

      it "入力した値で登録できている" do
        jsonResponse = JSON.parse(response.body)
        expect(jsonResponse["record"]["memo"]).to eq("メモTEST")
        expect(jsonResponse["record"]["date"]).to eq("2024-04-29T00:00:00.000Z")
        expect(jsonResponse["record"]["user_id"]).to eq(user.id)
      end
    end
  end

  describe "POST #create" do
    context "バリデーションエラー(記録日必須)" do
      before do
        request.headers.merge!(headers)
        request.headers.merge!(common_header)
        post :create, format: :json, params: { record: invalid_params }
      end

      it "データが追加されない" do
        expect(change(Record, :count).by(0))
      end

      it "ステータス422が返却される" do
        expect(response.status).to eq 422
      end
    end
  end

  describe "PUT #update" do
    context "未ログイン" do
      let(:record) { create(:record, title: "テストタイトル", content: "テストコンテンツ", user_id: user.id, id: 1) }

      before do
        request.headers.merge!(common_header)
        put :update, params: { id: 1, record: valid_params }
      end

      it "401(未認証のステータスコード)エラー" do
        expect(response.status).to eq 401
      end
    end
  end

  describe "PUT #update" do
    context "対象のデータが存在しない" do
      before do
        request.headers.merge!(headers)
        request.headers.merge!(common_header)
        put :update, params: { id: -1, record: valid_params }
      end

      it "404のエラー" do
        expect(response.status).to eq 404
      end
    end
  end

  describe "PUT #update" do
    context "記録日不足" do
      before do
        request.headers.merge!(headers)
        request.headers.merge!(common_header)
        put :update, params: { id: user.records.first.id, record: { date: "" } }
      end

      it "ステータス422が返却される" do
        expect(response.status).to eq 422
      end
    end
  end

  describe "PUT #update" do
    context "更新完了" do
      before do
        request.headers.merge!(headers)
        request.headers.merge!(common_header)
        patch :update, format: :json, params: { id: user.records.first.id, record: update_valid_params }
      end

      it "1件データが追加" do
        expect(change(Record, :count).by(0))
        expect(response.status).to eq 200
      end

      it "入力した値で更新できている" do
        jsonResponse = JSON.parse(response.body)
        expect(jsonResponse["record"]["memo"]).to eq("メモ更新TEST")
        expect(jsonResponse["record"]["date"]).to eq("2024-04-01T00:00:00.000Z")
        expect(jsonResponse["record"]["user_id"]).to eq(user.id)
      end
    end
  end
end
