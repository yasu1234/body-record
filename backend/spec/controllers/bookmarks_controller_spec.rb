require "rails_helper"

RSpec.describe Api::V1::BookmarksController, type: :controller do
  let!(:user) { create(:user, :without_records, :without_knowledges) }
  let!(:knowledge) { create(:knowledge) }
  let(:headers) { user.create_new_auth_token }
  let(:common_header) { { 'X-Requested-With': "XMLHttpRequest" } }
  let(:valid_params) { { user_id: user.id, knowledge_id: knowledge.id } }
  let(:invalid_param_lack_knowledge) { { user_id: user.id } }
  let(:invalid_param_lack_user) { {  knowledge_id: knowledge.id } }
  let(:update_valid_params) { { memo: "メモ更新TEST", date: "2024-04-01", images: [image] } }

  def create_records(count)
    create_list(:record, count, user:)
  end

  describe "POST #create" do
    context "未ログイン" do
      before do
        request.headers.merge!(common_header)
        post :create, format: :json, params: { bookmark: valid_params }
      end

      it "401(未認証のステータスコード)" do
        expect(response.status).to eq 401
      end
    end
  end

  describe "POST #create" do
    context "バリデーションエラー(knowledge_idが指定されていない)" do
      before do
        request.headers.merge!(headers)
        request.headers.merge!(common_header)
        post :create, format: :json, params: { bookmark: invalid_param_lack_knowledge }
      end

      it "404エラー" do
        expect(response.status).to eq 404
      end
    end
  end

  describe "POST #create" do
    context "ブックマーク完了" do
      before do
        request.headers.merge!(headers)
        request.headers.merge!(common_header)
        post :create, format: :json, params: { bookmark: valid_params }
      end

      it "1件データが追加" do
        expect(change(Bookmark, :count).by(1))
        expect(response.status).to eq 200
      end

      it "入力した値で登録できている" do
        jsonResponse = JSON.parse(response.body)
        expect(jsonResponse["knowledge"]["isBookmark"]).to eq(true)
        expect(jsonResponse["knowledge"]["id"]).to eq(knowledge.id)
      end
    end
  end

  describe "DELETE #destroy" do
    context "未ログイン" do
      before do
        request.headers.merge!(common_header)
        delete :destroy, params: { id: knowledge.id }, format: :json
      end

      it "401(未認証のステータスコード)エラー" do
        expect(response.status).to eq 401
      end
    end
  end

  describe "DELETE #destroy" do
    context "対象のデータが存在しない" do
      let!(:knowledge) { create(:knowledge, :with_bookmark) }

      before do
        request.headers.merge!(headers)
        request.headers.merge!(common_header)
        delete :destroy, params: { id: -1 }, format: :json
      end

      it "404のエラー" do
        expect(response.status).to eq 404
      end
    end
  end

  describe "DELETE #destroy" do
    context "削除成功" do
      let!(:knowledge) { create(:knowledge, :with_bookmark) }

      before do
        request.headers.merge!(headers)
        request.headers.merge!(common_header)
        delete :destroy, params: { id: knowledge.id, user_id: user.id }, format: :json
      end

      it "1件データが削除、ブックマークがOFFになっている" do
        expect(change(Bookmark, :count).by(-1))
        jsonResponse = JSON.parse(response.body)
        expect(jsonResponse["knowledge"]["isBookmark"]).to eq(false)
        expect(jsonResponse["knowledge"]["id"]).to eq(knowledge.id)
      end

      it "ステータス200" do
        expect(response.status).to eq 200
      end
    end
  end
end
