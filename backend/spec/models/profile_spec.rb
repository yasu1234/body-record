require "rails_helper"

RSpec.describe Profile, type: :model do
  describe "Association" do
    context "ユーザーを削除" do
      let(:user) { create(:user) }
      let(:profile) { create(:profile) }

      before do
        user.build_profile(profile: "test").save!
      end

      it "紐づくプロファイルデータも削除される" do
        expect { user.destroy }.to change(Profile, :count).by(-1)
      end
    end
  end
end
