require "rails_helper"

RSpec.describe Api::V1::RecordCommentsController, type: :controller do
  let!(:user) { create(:user, :with_records, :without_knowledges) }
  let(:headers) { user.create_new_auth_token }
  let(:common_header) { { 'X-Requested-With': "XMLHttpRequest" } }
  let(:record_id_lack_param) { { comment: "TESTコメント" } }

  def create_comments(count)
    create_list(:comment, count, user:)
  end

  describe "GET #index" do
    context "未ログイン" do
      before do
        request.headers.merge!(common_header)
        post :index, format: :json
      end

      it "401(未認証のステータスコード)が発生" do
        expect(response.status).to eq 401
      end
    end

    context "record_idのパラメータがない" do
      before do
        request.headers.merge!(headers)
        request.headers.merge!(common_header)
        post :index, format: :json
      end

      it "ステータスコード400が返却" do
        expect(response.status).to eq 400
      end
    end

    context "コメントが取得できる" do
      let!(:record) { create(:record, user:, memo: "メモTEST", date: "2024-05-03T00:00:00.000Z", open_status: 1) }
      let!(:comment1) { create(:comment, user:, comment: "メモTEST1", record_id: record.id) }
      let!(:comment2) { create(:comment, user:, comment: "メモTEST2", record_id: record.id) }
      let!(:comment3) { create(:comment, user:, comment: "メモTEST3", record_id: record.id) }

      before do
        request.headers.merge!(headers)
        request.headers.merge!(common_header)
        post :index, format: :json, params: { record_id: record.id }
      end

      it "ステータスコード200が返却" do
        expect(response.status).to eq 200
      end

      it "3件のデータが取得される" do
        json_response = JSON.parse(response.body)
        expect(json_response["comments"].count).to eq 3
      end
    end

    context "コメントが取得できる" do
      let!(:record) { create(:record, user:, memo: "メモTEST", date: "2024-05-03T00:00:00.000Z", open_status: 1) }
      let!(:comment1) { create(:comment, user:, comment: "メモTEST1", record_id: record.id) }
      let!(:comment2) { create(:comment, user:, comment: "メモTEST2", record_id: record.id) }
      let!(:comment3) { create(:comment, user:, comment: "メモTEST3", record_id: record.id) }

      before do
        request.headers.merge!(headers)
        request.headers.merge!(common_header)
        post :index, format: :json, params: { record_id: -1 }
      end

      it "ステータスコード200が返却" do
        expect(response.status).to eq 200
      end

      it "0件のデータが取得される" do
        json_response = JSON.parse(response.body)
        expect(json_response["comments"].count).to eq 0
      end
    end
  end

  describe "POST #create" do
    context "未ログイン" do
      let!(:record) { create(:record, user:, memo: "メモTEST", date: "2024-05-03T00:00:00.000Z", open_status: 1) }
      let!(:valid_params) { { record_id: record.id, comment: "TESTコメント成功" } }

      before do
        request.headers.merge!(common_header)
        post :create, format: :json, params: { comment: valid_params }
      end

      it "401(未認証のステータスコード)が発生" do
        expect(response.status).to eq 401
      end
    end

    context "record_idが不足" do
      let!(:record) { create(:record, user:, memo: "メモTEST", date: "2024-05-03T00:00:00.000Z", open_status: 1) }

      before do
        request.headers.merge!(headers)
        request.headers.merge!(common_header)
        post :create, format: :json, params: { comment: record_id_lack_param }
      end

      it "404エラーが発生" do
        expect(response.status).to eq 404
      end
    end

    context "コメント追加完了" do
      let!(:record) { create(:record, user:, memo: "メモTEST", date: "2024-05-03T00:00:00.000Z", open_status: 1) }
      let(:valid_params) { { record_id: record.id, comment: "TESTコメント成功" } }

      before do
        request.headers.merge!(headers)
        request.headers.merge!(common_header)
        post :create, format: :json, params: { comment: valid_params }
      end

      it "ステータスコードが200" do
        expect(response.status).to eq 200
      end

      it "追加したコメントがレスポンスに含めれている" do
        json_response = JSON.parse(response.body)
        expect(json_response["record"]["comments"].count).to eq 1
        expect(json_response["record"]["comments"][0]["comment"]).to eq "TESTコメント成功"
      end
    end
  end

  describe "PUT #update" do
    context "未ログイン" do
      let!(:record) { create(:record, user:, id: 2, memo: "メモTEST", date: "2024-05-03T00:00:00.000Z", open_status: 1) }
      let(:valid_params) { { record_id: record.id, comment: "TESTコメント成功" } }

      before do
        request.headers.merge!(common_header)
        post :update, format: :json, params: { comment: valid_params, id: record.id }
      end

      it "401(未認証のステータスコード)が発生" do
        expect(response.status).to eq 401
      end
    end

    context "comment_idが不足" do
      let!(:record) { create(:record, user:, id: 2, memo: "メモTEST", date: "2024-05-03T00:00:00.000Z", open_status: 1) }
      let(:valid_params) { { record_id: record.id, comment: "TESTコメント成功" } }

      before do
        request.headers.merge!(headers)
        request.headers.merge!(common_header)
        post :update, format: :json, params: { comment: valid_params, id: record.id }
      end

      it "404エラーが発生" do
        expect(response.status).to eq 404
      end
    end

    context "コメント更新完了" do
      let!(:record) { create(:record, user:, id: 2, memo: "メモTEST", date: "2024-05-03T00:00:00.000Z", open_status: 1) }
      let!(:comment1) { create(:comment, user:, comment: "メモTEST", record_id: record.id) }
      let(:valid_params) { { record_id: record.id, comment: "TESTコメント成功" } }

      before do
        request.headers.merge!(headers)
        request.headers.merge!(common_header)
        post :update, format: :json, params: { comment: valid_params, id: comment1.id }
      end

      it "ステータスコードが200" do
        expect(response.status).to eq 200
      end

      it "更新したコメントがレスポンスに含めれている" do
        json_response = JSON.parse(response.body)
        expect(json_response["comment"]["comment"]).to eq "TESTコメント成功"
      end
    end
  end

  describe "DELETE #destroy" do
    context "未ログイン" do
      let!(:record) { create(:record, user:, id: 2, memo: "メモTEST", date: "2024-05-03T00:00:00.000Z", open_status: 1) }
      let!(:comment1) { create(:comment, user:, comment: "メモTEST", record_id: record.id) }

      before do
        request.headers.merge!(common_header)
        post :destroy, format: :json, params: { id: comment1.id }
      end

      it "401(未認証のステータスコード)が発生" do
        expect(response.status).to eq 401
      end
    end

    context "comment_idが不足" do
      before do
        request.headers.merge!(headers)
        request.headers.merge!(common_header)
        post :destroy, format: :json, params: { id: -100 }
      end

      it "404エラーが発生" do
        expect(response.status).to eq 404
      end
    end

    context "コメント削除完了" do
      let!(:record) { create(:record, user:, id: 2, memo: "メモTEST", date: "2024-05-03T00:00:00.000Z", open_status: 1) }
      let!(:comment1) { create(:comment, user:, comment: "メモTEST", record_id: record.id) }

      before do
        request.headers.merge!(headers)
        request.headers.merge!(common_header)
        post :destroy, format: :json, params: { id: comment1.id }
      end

      it "ステータスコードが200" do
        expect(response.status).to eq 200
      end

      it "更新したコメントがレスポンスに含めれている" do
        json_response = JSON.parse(response.body)
        expect(json_response["comment"]["id"]).to eq comment1.id
      end
    end
  end
end
