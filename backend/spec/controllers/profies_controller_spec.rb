require "rails_helper"

RSpec.describe Api::V1::ProfilesController, type: :controller do
  let!(:user) { create(:user, :with_profile) }
  let(:headers) { user.create_new_auth_token }
  let(:common_header) { { 'X-Requested-With': "XMLHttpRequest" } }
  let(:image) { file_fixture("image.png") }
  let(:valid_params) { { profile: "プロファイルテスト", goal_weight: 60, goal_fat_percentage: 10 } }

  describe "GET #show" do
    context "未ログイン" do
      before do
        request.headers.merge!(common_header)
        get :show, params: { id: user.id }, format: :json
      end

      it "401(未認証のステータスコード)" do
        expect(response.status).to eq 401
      end
    end
  end

  describe "GET #show" do
    context "ログイン済" do
      before do
        request.headers.merge!(headers)
        request.headers.merge!(common_header)
        get :show, params: { id: user.id }, format: :json
      end

      it "ステータス200が返却される" do
        expect(response.status).to eq 200
      end

      it "プロフィールが登録されている" do
        json_response = JSON.parse(response.body)
        expect(json_response["user"]["profile"]["profile"]).to eq "よろしくお願いします"
        expect(json_response["user"]["profile"]["goal_weight"]).to eq 65.1
        expect(json_response["user"]["profile"]["goal_fat_percentage"]).to eq 11.2
      end
    end
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
      let!(:user_not_profile) { create(:user) }

      before do
        request.headers.merge!(headers)
        request.headers.merge!(common_header)
        post :create, format: :json, params: valid_params
      end

      it "1件データが追加" do
        expect(change(Profile, :count).by(1))
        expect(response.status).to eq 200
      end

      it "入力した値で登録できている" do
        jsonResponse = JSON.parse(response.body)
        expect(jsonResponse["user"]["profile"]).to eq "プロファイルテスト"
        expect(jsonResponse["user"]["goal_weight"]).to eq 60
        expect(jsonResponse["user"]["goal_fat_percentage"]).to eq 10
        expect(jsonResponse["user"]["user_id"]).to eq(user.id)
      end
    end
  end
end
