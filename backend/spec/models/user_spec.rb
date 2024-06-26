require "rails_helper"

RSpec.describe User, type: :model do
  describe "画像バリデーション" do
    it { is_expected.to validate_content_type_of(:image).allowing("image/png", "image/jpg") }
    it { is_expected.to validate_content_type_of(:image).rejecting("text/plain", "image/pdf") }

    it { is_expected.to validate_size_of(:image).less_than(5.megabytes) }
  end

  describe "#image_urls" do
    context "画像を登録" do
      let(:user) { create(:user) }
      let(:image1) { fixture_file_upload("spec/fixtures/image.png", "image/png") }

      before do
        user.image.attach(image1)
      end

      it "登録した画像の情報を取得できる" do
        url = user.image_url
        expect(url[:url]).to include("/rails/active_storage/blobs")
        expect(url[:filename]).to eq("image.png")
      end
    end
  end

  context "ユーザーを削除" do
    let(:user) { create(:user) }
    let(:other_user) { create(:user) }

    before do
      user.support!(other_user)
    end

    it "紐づく応援データも削除される" do
      expect { user.destroy }.to change(Support, :count).by(-1)
    end
  end

  describe "#guest" do
    it "ゲストユーザーが作成される" do
      expect { User.guest! }.to change { User.count }.by(1)
      guest_user = User.find_by(email: ENV["GUEST_USER_ADDRESS"])
      expect(guest_user).to be_present
      expect(guest_user.name).to eq "ゲストユーザー"
      expect(guest_user.status).to eq 1
    end
  end

  describe "#check_support_mine" do
    let(:user) { create(:user) }
    let(:other_user) { create(:user) }

    context "応援するユーザーが自分以外" do
      it "falseが返却される" do
        expect(user.check_support_mine(other_user)).to be false
      end
    end
  end

  describe "#check_support_mine" do
    let(:user) { create(:user, :fixed_id) }

    context "応援するユーザーが自分自身" do
      it "trueが返却される" do
        expect(user.check_support_mine(user)).to be true
      end
    end
  end

  describe "#support" do
    let(:user) { create(:user) }
    let(:other_user) { create(:user) }

    it "応援ができる" do
      expect { user.support!(other_user) }.to change { Support.count }.by(1)
      expect(user.supportings).to include(other_user)
      expect(other_user.supporters).to include(user)
    end
  end
end
