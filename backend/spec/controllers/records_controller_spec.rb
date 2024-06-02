require "rails_helper"

RSpec.describe Api::V1::RecordsController, type: :controller do
  let!(:user) { create(:user, :with_records, :without_knowledges) }
  let(:headers) { user.create_new_auth_token }
  let(:image) { file_fixture("image.png") }
  let(:valid_params) { { memo: "メモTEST", date: "2024-04-29", images: [image] } }
  let(:invalid_params) { { memo: "", content: "テストコンテンツ", user_id: user.id } }
  let(:update_valid_params) { { memo: "メモ更新TEST", date: "2024-04-01", images: [image] } }

  def create_records(count)
    create_list(:record, count, user:)
  end

  describe "GET #index" do
    context "未ログイン" do
      let!(:record) { create_records(1) }

      before do
        get :index, format: :json
      end

      it "401(未認証のステータスコード)" do
        expect(response.status).to eq 401
      end
    end
  end

  describe "GET #index" do
    context "ログイン済" do
      let(:user) { create(:user, :without_records, :without_knowledges) }
      let!(:record) { create_records(1) }

      before do
        request.headers.merge!(headers)
        get :index, format: :json
      end

      it "ステータス200が返却される" do
        expect(response.status).to eq 200
      end

      it "データが1件取得できる" do
        json_response = JSON.parse(response.body)
        expect(json_response["records"].count).to eq 1
        expect(json_response["totalPage"]).to eq 1
      end
    end
  end

  describe "GET #index" do
    context "2ページ目のデータ" do
      let(:user) { create(:user, :without_records, :without_knowledges) }
      let!(:record) { create_records(31) }

      before do
        request.headers.merge!(headers)
        get :index, format: :json, params: { page: 2 }
      end

      it "ステータス200が返却される" do
        expect(response.status).to eq 200
      end

      it "件数は1件で、合計ページは2" do
        json_response = JSON.parse(response.body)
        expect(json_response["records"].count).to eq 1
        expect(json_response["totalPage"]).to eq 2
      end
    end
  end

  describe "GET #index" do
    context "非公開データあり" do
      let(:user) { create(:user, :without_records, :without_knowledges) }
      let!(:record) { create(:record, user:, open_status: 0) }

      before do
        request.headers.merge!(headers)
        get :index, format: :json
      end

      it "ステータス200が返却される" do
        expect(response.status).to eq 200
      end

      it "件数は0件で、合計ページは0" do
        json_response = JSON.parse(response.body)
        expect(json_response["records"].count).to eq 0
        expect(json_response["totalPage"]).to eq 0
      end
    end
  end

  describe "GET #index" do
    context "データ0件" do
      let(:user) { create(:user, :without_records, :without_knowledges) }

      before do
        request.headers.merge!(headers)
        get :index, format: :json
      end

      it "ステータス200が返却される" do
        expect(response.status).to eq 200
      end

      it "件数は0件で、合計ページは0" do
        json_response = JSON.parse(response.body)
        expect(json_response["records"].count).to eq 0
        expect(json_response["totalPage"]).to eq 0
      end
    end
  end

  describe "GET #index" do
    context "メモのキーワード検索" do
      let(:user) { create(:user, :without_records, :without_knowledges) }
      let!(:record1) { create(:record, user:, memo: "メモTEST", date: "2024-05-03T00:00:00.000Z", open_status: 1) }
      let!(:record2) { create(:record, user:, memo: "メモ1メモ", date: "2024-05-02T00:00:00.000Z", open_status: 1) }
      let!(:record3) { create(:record, user:, memo: "TEST1", date: "2024-05-01T00:00:00.000Z", open_status: 1) }

      before do
        request.headers.merge!(headers)
        get :index, format: :json, params: { keyword: "メモ" }
      end

      it "ステータス200が返却される" do
        expect(response.status).to eq 200
      end

      it "件数は2件で、合計ページは1" do
        json_response = JSON.parse(response.body)
        expect(json_response["records"].count).to eq 2
        expect(json_response["totalPage"]).to eq 1
        expect(json_response["records"][0]["memo"]).to eq "メモTEST"
        expect(json_response["records"][1]["memo"]).to eq "メモ1メモ"
      end
    end
  end

  describe "POST #create" do
    context "未ログイン" do
      before do
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

  describe "GET #show" do
    context "未ログイン" do
      let!(:record) { create_records(1).first }

      before do
        get :show, params: { id: record.id }, format: :json
      end

      it "401(未認証のステータスコード)" do
        expect(response.status).to eq 401
      end
    end
  end

  describe "GET #show" do
    context "ID不足" do
      let(:record) { create_records(1).first }

      before do
        request.headers.merge!(headers)
        get :show, params: { id: "" }, format: :json
      end

      it "404エラー" do
        expect(response.status).to eq 404
      end
    end
  end

  describe "GET #show" do
    context "対象のデータが存在しない" do
      let(:record) { create(:record, user_id: user.id, id: 1) }

      before do
        request.headers.merge!(headers)
        get :show, params: { id: 150 }, format: :json
      end

      it "404エラー" do
        expect(response.status).to eq 404
      end
    end
  end

  describe "GET #show" do
    context "対象のデータを取得できる" do
      let(:record) { create(:record, user:) }

      before do
        request.headers.merge!(headers)
        get :show, params: { id: record.id }, format: :json
      end

      it "ステータス200が返却される" do
        expect(response.status).to eq 200
      end

      it "正しいデータが取得できる" do
        jsonResponse = JSON.parse(response.body)
        expect(jsonResponse["record"]["date"]).to eq("2024-05-03T00:00:00.000Z")
        expect(jsonResponse["record"]["weight"]).to eq(65.1)
        expect(jsonResponse["record"]["fat_percentage"]).to eq(11.2)
        expect(jsonResponse["record"]["memo"]).to eq("サンプルメモ")
        expect(jsonResponse["record"]["id"]).to eq(record.id)
      end
    end
  end

  describe "PUT #update" do
    context "未ログイン" do
      let(:record) { create(:record, title: "テストタイトル", content: "テストコンテンツ", user_id: user.id, id: 1) }

      before do
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
        put :update, params: { id: user.records.first.id, record: { date: "" } }
      end

      it "ステータス422が返却される" do
        expect(response.status).to eq 422
      end
    end
  end

  describe "PATCH #update" do
    context "更新完了" do
      before do
        request.headers.merge!(headers)
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

  describe "DELETE #destroy" do
    context "未ログイン" do
      before do
        delete :destroy, params: { id: user.records.first.id }, format: :json
      end

      it "401(未認証のステータスコード)エラー" do
        expect(response.status).to eq 401
      end
    end
  end

  describe "DELETE #destroy" do
    context "ID 不足" do
      let(:user) { create(:user, :with_records_over, :without_knowledges) }

      before do
        request.headers.merge!(headers)
        delete :destroy, params: { id: "" }, format: :json
      end

      it "404のエラー" do
        expect(response.status).to eq 404
      end
    end
  end

  describe "DELETE #destroy" do
    context "対象のデータが存在しない" do
      let(:user) { create(:user, :with_records_over, :without_knowledges) }

      before do
        request.headers.merge!(headers)
        delete :destroy, params: { id: -1 }, format: :json
      end

      it "404のエラー" do
        expect(response.status).to eq 404
      end
    end
  end

  describe "DELETE #destroy" do
    context "削除成功" do
      before do
        request.headers.merge!(headers)
        delete :destroy, params: { id: user.records.first.id }, format: :json
      end

      it "1件データが削除" do
        expect(change(Record, :count).by(-1))
      end

      it "ステータス200" do
        expect(response.status).to eq 200
      end
    end
  end

  describe "GET #get_target_user_record" do
    context "ユーザーのデータ5件" do
      before do
        request.headers.merge!(headers)
        get "get_target_user_record", params: { user_id: user.id }, format: :json
      end

      it "ステータス200" do
        expect(response.status).to eq 200
      end

      it "データは5件分取得" do
        json_response = JSON.parse(response.body)
        expect(json_response["records"].count).to eq 5
      end
    end

    describe "GET #get_target_user_record" do
      context "成功(対象のユーザーがいない)" do
        before do
          request.headers.merge!(headers)
          get "get_target_user_record", params: { user_id: -1 }, format: :json
        end

        it "ステータス200" do
          expect(response.status).to eq 200
        end

        it "データは0件" do
          json_response = JSON.parse(response.body)
          expect(json_response["records"].count).to eq 0
        end
      end
    end

    describe "GET #get_target_user_record" do
      context "ユーザーのデータ7件" do
        let(:user) { create(:user, :with_records_over, :without_knowledges) }

        before do
          request.headers.merge!(headers)
          get "get_target_user_record", params: { user_id: user.id }, format: :json
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

    describe "GET #get_record_month" do
      context "targetYearが指定されていない" do
        let(:user) { create(:user, :without_records, :without_knowledges) }

        before do
          request.headers.merge!(headers)
          get "get_record_month", params: { user_id: user.id, targetMonth: 4 }, format: :json
        end

        it "ステータス422" do
          expect(response.status).to eq 404
        end
      end
    end

    describe "GET #get_record_month" do
      context "targetMonthが指定されていない" do
        let(:user) { create(:user, :without_records, :without_knowledges) }

        before do
          request.headers.merge!(headers)
          get "get_record_month", params: { user_id: user.id, targetYear: 2024 }, format: :json
        end

        it "ステータス422" do
          expect(response.status).to eq 404
        end
      end
    end

    describe "GET #get_record_month" do
      context "user_idが指定されていない" do
        let(:user) { create(:user, :without_records, :without_knowledges) }

        before do
          request.headers.merge!(headers)
          get "get_record_month", params: { targetYear: 2024, targetMonth: 4 }, format: :json
        end

        it "ステータス422" do
          expect(response.status).to eq 404
        end
      end
    end

    describe "GET #get_record_month" do
      context "4月のデータ取得(記録を登録していない)" do
        let(:user) { create(:user, :without_records, :without_knowledges) }

        before do
          request.headers.merge!(headers)
          get "get_record_month", params: { user_id: user.id, targetYear: 1200, targetMonth: 4 }, format: :json
        end

        it "ステータス200" do
          expect(response.status).to eq 200
        end

        it "データは30件分取得" do
          json_response = JSON.parse(response.body)
          expect(json_response["records"].count).to eq 30
        end

        it "体重・体脂肪率は0で取得される" do
          json_response = JSON.parse(response.body)

          json_response["records"].each_with_index do |record, _index|
            expect(record["weight"]).to eq 0
            expect(record["fat_percentage"]).to eq 0
          end
        end
      end
    end

    describe "GET #get_record_month" do
      context "4月のデータ取得" do
        let(:user) { create(:user, :without_records, :without_knowledges) }
        let!(:record1) { create(:record, user:, memo: "メモTEST", date: "2024-04-03T00:00:00.000Z", open_status: 1) }
        let!(:record2) { create(:record, user:, memo: "メモ1メモ", date: "2024-05-01T00:00:00.000Z", open_status: 1) }
        let!(:record3) { create(:record, user:, memo: "TEST1", date: "2024-04-01T00:00:00.000Z", weight: 72.1, fat_percentage: 13.2, open_status: 1) }

        before do
          request.headers.merge!(headers)
          get "get_record_month", params: { user_id: user.id, targetYear: 2024, targetMonth: 4 }, format: :json
        end

        it "ステータス200" do
          expect(response.status).to eq 200
        end

        it "データは30件分取得" do
          json_response = JSON.parse(response.body)
          expect(json_response["records"].count).to eq 30
        end

        it "4/1は体重と体脂肪率の登録あり、4/2は0で取得される" do
          json_response = JSON.parse(response.body)
          expect(json_response["records"][0]["weight"]).to eq 72.1
          expect(json_response["records"][0]["fat_percentage"]).to eq 13.2
          expect(json_response["records"][1]["weight"]).to eq 0
          expect(json_response["records"][1]["fat_percentage"]).to eq 0
        end
      end
    end
  end
end
