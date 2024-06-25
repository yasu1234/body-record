require "rails_helper"

RSpec.describe Api::V1::RecordImagesController, type: :controller do
  let!(:user) { create(:user, :with_records, :without_knowledges) }
  let(:header) { user.create_new_auth_token }
  let(:common_header) { { 'X-Requested-With': "XMLHttpRequest" } }
  let(:image) { create(file_fixture("image.png")) }

  describe "DELETE #destroy" do
    context "未ログイン" do
      before do
        request.headers.merge!(common_header)
        delete :destroy, format: :json, params: { id: 100 }
      end

      it "401(未認証のステータスコード)が返却される" do
        expect(response.status).to eq 401
      end
    end

    context "image_idが指定されていない" do
      let!(:record) { create(:record, user:) }

      before do
        request.headers.merge!(header)
        request.headers.merge!(common_header)
        delete :destroy, format: :json, params: { id: user.records.first.id, image_id: -1 }
      end

      it "ステータス404が返却される" do
        expect(response.status).to eq 404
      end
    end

    context "削除が成功する" do
      let(:image1) { fixture_file_upload("spec/fixtures/image.png", "image/png") }

      before do
        request.headers.merge!(header)
        request.headers.merge!(common_header)
        user.records.first.images.attach(image1)
        delete :destroy, format: :json, params: { id: user.records.first.id, image_id: user.records.first.images.first.id }
      end

      it "ステータス200が返却される" do
        expect(response.status).to eq 200
      end

      it "画像が削除され0件になる" do
        json_response = JSON.parse(response.body)
        expect(json_response["image_urls"].count).to eq 0
      end
    end
  end
end
