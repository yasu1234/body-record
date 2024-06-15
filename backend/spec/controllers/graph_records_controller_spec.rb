require "rails_helper"

RSpec.describe Api::V1::GraphRecordsController, type: :controller do
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
    context "targetYearが指定されていない" do
        let(:user) { create(:user, :without_records, :without_knowledges) }

        before do
          request.headers.merge!(headers)
          get :index, params: { user_id: user.id, targetMonth: 4 }, format: :json
        end

        it "ステータス422" do
          expect(response.status).to eq 404
        end
      end
    end

    describe "GET #index" do
      context "targetMonthが指定されていない" do
        let(:user) { create(:user, :without_records, :without_knowledges) }

        before do
          request.headers.merge!(headers)
          get :index, params: { user_id: user.id, targetYear: 2024 }, format: :json
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
          get :index, params: { targetYear: 2024, targetMonth: 4 }, format: :json
        end

        it "ステータス422" do
          expect(response.status).to eq 404
        end
      end
    end

    describe "GET #index" do
      context "4月のデータ取得(記録を登録していない)" do
        let(:user) { create(:user, :without_records, :without_knowledges) }

        before do
          request.headers.merge!(headers)
          get :index, params: { user_id: user.id, targetYear: 1200, targetMonth: 4 }, format: :json
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

    describe "GET #index" do
      context "4月のデータ取得" do
        let(:user) { create(:user, :without_records, :without_knowledges) }
        let!(:record1) { create(:record, user:, memo: "メモTEST", date: "2024-04-03T00:00:00.000Z", open_status: 1) }
        let!(:record2) { create(:record, user:, memo: "メモ1メモ", date: "2024-05-01T00:00:00.000Z", open_status: 1) }
        let!(:record3) { create(:record, user:, memo: "TEST1", date: "2024-04-01T00:00:00.000Z", weight: 72.1, fat_percentage: 13.2, open_status: 1) }

        before do
          request.headers.merge!(headers)
          get :index, params: { user_id: user.id, targetYear: 2024, targetMonth: 4 }, format: :json
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
