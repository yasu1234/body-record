require "rails_helper"

RSpec.describe Api::V1::ContactsController, type: :controller do
  let!(:user) { create(:user) }
  let(:headers) { user.create_new_auth_token }
  let(:common_header) { { 'X-Requested-With': "XMLHttpRequest" } }
  let(:valid_params) { { content: "問い合わせTEST" } }
  let(:invalid_params) { { content: "" } }
  let(:valid_status_params) { { content: "問い合わせTEST", status: 1 } }

  describe "GET #index" do
    context "未ログイン" do
      let!(:contact1) { create(:contact) }
      let!(:contact2) { create(:contact) }
      let!(:contact3) { create(:contact) }

      before do
        request.headers.merge!(common_header)
        get :index, format: :json
      end

      it "ステータスコードは200" do
        expect(response.status).to eq 200
      end

      it "データが3件取得できる" do
        json_response = JSON.parse(response.body)
        expect(json_response["contacts"].count).to eq 3
      end
    end
  end

  describe "GET #show" do
    context "未ログイン" do
      let!(:contact1) { create(:contact) }

      before do
        request.headers.merge!(common_header)
        get :show, params: { id: contact1.id }, format: :json
      end

      it "401(未認証のステータスコード)" do
        expect(response.status).to eq 401
      end
    end
  end

  describe "GET #show" do
    context "ID不足" do
      let!(:contact1) { create(:contact) }

      before do
        request.headers.merge!(headers)
        request.headers.merge!(common_header)
        get :show, params: { id: "" }, format: :json
      end

      it "404エラー" do
        expect(response.status).to eq 404
      end
    end
  end

  describe "GET #show" do
    context "対象のデータが存在しない" do
      let!(:contact1) { create(:contact) }

      before do
        request.headers.merge!(headers)
        request.headers.merge!(common_header)
        get :show, params: { id: -1 }, format: :json
      end

      it "404エラー" do
        expect(response.status).to eq 404
      end
    end
  end

  describe "GET #show" do
    context "対象のデータを取得できる" do
      let!(:contact1) { create(:contact) }

      before do
        request.headers.merge!(headers)
        request.headers.merge!(common_header)
        get :show, params: { id: contact1.id }, format: :json
      end

      it "ステータス200が返却される" do
        expect(response.status).to eq 200
      end

      it "正しいデータが取得できる" do
        jsonResponse = JSON.parse(response.body)
        expect(jsonResponse["contact"]["id"]).to eq contact1.id
      end
    end
  end

  describe "POST #create" do
    context "未ログイン" do
      before do
        request.headers.merge!(common_header)
        post :create, format: :json, params: { contact: valid_params }
      end

      it "データが１件追加" do
        expect(change(Contact, :count).by(1))
        expect(response.status).to eq 200
      end

      it "ユーザーIDは登録されていない" do
        jsonResponse = JSON.parse(response.body)
        expect(jsonResponse["contact"]["user_id"]).to be nil
      end
    end
  end

  describe "POST #create" do
    context "バリデーションエラー" do
      before do
        request.headers.merge!(headers)
        request.headers.merge!(common_header)
        post :create, format: :json, params: { contact: invalid_params }
      end

      it "ステータス422が返却" do
        expect(response.status).to eq 422
      end
    end
  end

  describe "POST #create" do
    context "作成完了" do
      before do
        request.headers.merge!(headers)
        request.headers.merge!(common_header)
        post :create, format: :json, params: { contact: valid_params }
      end

      it "1件データが追加" do
        expect(change(Contact, :count).by(1))
        expect(response.status).to eq 200
      end

      it "入力した値で登録できている" do
        jsonResponse = JSON.parse(response.body)
        expect(jsonResponse["contact"]["content"]).to eq "問い合わせTEST"
        expect(jsonResponse["contact"]["user_id"]).to eq user.id
      end
    end
  end

  describe "PUT #update" do
    context "未ログイン" do
      let!(:contact1) { create(:contact) }

      before do
        request.headers.merge!(common_header)
        put :update, format: :json, params: { id: contact1.id, contact: valid_params }
      end

      it "ステータス401が返却される" do
        expect(response.status).to eq 401
      end
    end
  end

  describe "PUT #update" do
    context "バリデーションエラー" do
      let!(:contact1) { create(:contact) }

      before do
        request.headers.merge!(headers)
        request.headers.merge!(common_header)
        put :update, format: :json, params: { id: contact1.id, contact: invalid_params }
      end

      it "ステータス422が返却される" do
        expect(response.status).to eq 422
      end
    end
  end

  describe "PUT #update" do
    context "バリデーションエラー" do
      let!(:contact1) { create(:contact) }

      before do
        request.headers.merge!(headers)
        request.headers.merge!(common_header)
        put :update, format: :json, params: { id: contact1.id, contact: valid_status_params }
      end

      it "ステータス200が返却される" do
        expect(change(Contact, :count).by(0))
        expect(response.status).to eq 200
      end

      it "入力した値で登録できている" do
        jsonResponse = JSON.parse(response.body)
        expect(jsonResponse["contact"]["content"]).to eq "問い合わせTEST"
        expect(jsonResponse["contact"]["status"]).to eq 1
      end
    end
  end
end
