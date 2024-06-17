require "rails_helper"

RSpec.describe Api::V1::UsersController, type: :controller do
  let(:user) { create(:user, :with_records, :without_knowledges) }
  let(:headers) { user.create_new_auth_token }
  let(:common_header) { { 'X-Requested-With': "XMLHttpRequest" } }

  def create_records(count)
    create_list(:record, count, user:)
  end

  describe "GET #index" do
    context "全件取得(パラメータ指定なし)" do
      let!(:user1) { create(:user, id: 1, name: "test1") }
      let!(:user2) { create(:user, id: 2, name: "test2") }
      let!(:user3) { create(:user, id: 3, name: "test3") }
      let!(:user4) { create(:user, id: 4, name: "test4") }

      before do
        request.headers.merge!(headers)
        request.headers.merge!(common_header)
        get :index, format: :json
      end

      it "ステータス200" do
        expect(response.status).to eq 200
      end

      it "データは5件取得(テストデータとlet(:user)の合わせた件数)" do
        json_response = JSON.parse(response.body)
        expect(json_response["users"].count).to eq 5
      end
    end

    context "キーワードでユーザ名の絞り込み" do
      let!(:user1) { create(:user, id: 1, name: "test1") }
      let!(:user2) { create(:user, id: 2, name: "test23") }
      let!(:user3) { create(:user, id: 3, name: "test3") }

      before do
        request.headers.merge!(headers)
        request.headers.merge!(common_header)
        get :index, format: :json, params: { keyword: "3" }
      end

      it "ステータス200" do
        expect(response.status).to eq 200
      end

      it "データは2件取得" do
        json_response = JSON.parse(response.body)
        expect(json_response["users"].count).to eq 2
        expect(json_response["users"][0]["user"]["name"]).to eq "test23"
        expect(json_response["users"][1]["user"]["name"]).to eq "test3"
      end
    end

    describe "GET #index" do
      context "応援しているユーザーで絞り込み" do
        let!(:user1) { create(:user, id: 1, name: "test1") }
        let!(:user2) { create(:user, id: 2, name: "test23") }
        let!(:user3) { create(:user, id: 3, name: "test3") }

        before do
          request.headers.merge!(headers)
          request.headers.merge!(common_header)
          user.support!(user1)
          get :index, format: :json, params: { isSupportOnly: true }
        end

        it "ステータス200" do
          expect(response.status).to eq 200
        end

        it "データは1件取得" do
          json_response = JSON.parse(response.body)
          expect(json_response["users"].count).to eq 1
          expect(json_response["users"][0]["user"]["id"]).to eq 1
        end
      end
    end
  end

  describe "GET #show" do
    context "対象のユーザーを取得できるパターン" do
      let!(:user1) { create(:user, id: 1) }

      before do
        request.headers.merge!(headers)
        request.headers.merge!(common_header)
        get :show, params: { id: user1.id }, format: :json
      end

      it "ステータス200" do
        expect(response.status).to eq 200
      end

      it "データは5件分取得" do
        json_response = JSON.parse(response.body)
        expect(json_response["user"]["name"]).to eq user1.name
      end
    end

    context "対象のユーザーがいないパターン" do
      before do
        request.headers.merge!(headers)
        request.headers.merge!(common_header)
        get :show, params: { id: -1 }, format: :json
      end

      it "ステータス404" do
        expect(response.status).to eq 404
      end
    end
  end
end
