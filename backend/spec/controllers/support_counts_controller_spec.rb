require "rails_helper"

RSpec.describe Api::V1::SupportCountsController, type: :controller do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:headers) { user.create_new_auth_token }

  describe "GET #index" do
    context "未ログイン" do
      before do
        post :index, format: :json, params: { user_id: user.id }
      end

      it "ステータス401が返却される" do
        expect(response.status).to eq 401
      end
    end
  end
end
