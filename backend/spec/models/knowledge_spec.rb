require "rails_helper"

RSpec.describe Knowledge, type: :model do
  describe "Association" do
    context "ユーザーを削除" do
      let(:user) { create(:user) }

      before do
        user.save
        user.knowledges.create!(title: "test", content: "test")
      end

      it "紐づく記事データも削除される" do
        expect { user.destroy }.to change(Knowledge, :count).by(-1)
      end
    end
  end

  describe "画像バリデーション" do
    it { is_expected.to validate_content_type_of(:images).allowing("image/png", "image/jpg") }
    it { is_expected.to validate_content_type_of(:images).rejecting("text/plain", "image/pdf") }

    it { is_expected.to validate_size_of(:images).less_than(5.megabytes) }
  end

  describe "バリデーションチェック" do
    let(:knowledge) { create(:knowledge) }

    it "登録情報は正しい" do
      expect(knowledge).to be_valid
    end

    it "タイトルはnilが許容されていない" do
      knowledge.title = nil
      expect(knowledge).to be_invalid
    end

    it "内容は5000文字以上は許容されていない" do
      knowledge.content = "a" * 5001
      expect(knowledge).to be_invalid
    end
  end

  describe "#image_urls" do
    context "画像を登録" do
      let(:knowledge) { create(:knowledge) }
      let(:image1) { fixture_file_upload("spec/fixtures/image.png", "image/png") }

      before do
        knowledge.images.attach(image1)
      end

      it "登録した画像の情報を取得できる" do
        urls = knowledge.image_urls
        expect(urls.count).to eq(1)
        expect(urls.first[:url]).to include("http://localhost:3000/rails/active_storage/blobs")
        expect(urls.first[:filename]).to eq("image.png")
      end
    end
  end
end
