require "rails_helper"

RSpec.describe Api::V1::KnowledgeCommentsController, type: :controller do
  let!(:user) { create(:user) }
  let(:headers) { user.create_new_auth_token }
  let!(:knowledge) { create(:knowledge, user:, id: 100, title: "Title") }
  let(:comment) { create(:comment, user:, comment: "メモTEST", knowledge_id: knowledge.id) }
  let(:valid_params) { { knowledge_id: knowledge.id, comment: "TESTコメント成功" } }
  let(:knowledge_id_lack_param) { { comment: "TESTコメント" } }

  def create_comments(count)
    create_list(:comment, count, user:)
  end

  describe "GET #index" do
    context "未ログイン" do
      before do
        post :index, format: :json
      end

      it "401(未認証のステータスコード)が発生" do
        expect(response.status).to eq 401
      end
    end

    context "knowledge_idのパラメータがない" do
      before do
        request.headers.merge!(headers)
        post :index, format: :json
      end
  
      it "ステータスコード400が返却" do
        expect(response.status).to eq 400
      end
    end

    context "コメントが取得できる" do
      let!(:comment1) { create(:comment, user:, comment: "メモTEST1", knowledge_id: 100) }
      let!(:comment2) { create(:comment, user:, comment: "メモTEST2", knowledge_id: 100) }
      let!(:comment3) { create(:comment, user:, comment: "メモTEST3", knowledge_id: 100) }

      before do
        request.headers.merge!(headers)
        post :index, format: :json, params: { knowledge_id: 100 }
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
      let!(:comment1) { create(:comment, user:, comment: "メモTEST1", knowledge_id: 100) }
      let!(:comment2) { create(:comment, user:, comment: "メモTEST2", knowledge_id: 100) }
      let!(:comment3) { create(:comment, user:, comment: "メモTEST3", knowledge_id: 100) }
  
      before do
        request.headers.merge!(headers)
        post :index, format: :json, params: { knowledge_id: 101 }
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
      before do
        post :create, format: :json, params: valid_params
      end

      it "401(未認証のステータスコード)が発生" do
        expect(response.status).to eq 401
      end
    end

    context "record_idが不足" do
      before do
        request.headers.merge!(headers)
        post :create, format: :json, params: knowledge_id_lack_param
      end
  
      it "404エラーが発生" do
        expect(response.status).to eq 404
      end
    end

    context "コメント追加完了" do
      before do
        request.headers.merge!(headers)
        post :create, format: :json, params: valid_params
      end
    
      it "ステータスコードが200" do
        expect(response.status).to eq 200
      end

      it "追加したコメントがレスポンスに含めれている" do
        json_response = JSON.parse(response.body)
        expect(json_response["knowledge"]["comments"].count).to eq 1
        expect(json_response["knowledge"]["comments"][0]["comment"]).to eq "TESTコメント成功"
      end
    end
  end
end
