require "rails_helper"

RSpec.describe Bookmark, type: :model do
  describe "Association" do
    context "ユーザーを削除" do
      let(:user) { create(:user) }
      let(:knowledge) { create(:knowledge) }

      before do
        user.save
        user.bookmarks.create!(knowledge_id: knowledge.id, user_id: user.id)
      end

      it "紐づくブックマークも削除される" do
        expect { user.destroy }.to change(Bookmark, :count).by(-1)
      end
    end

    context "ノウハウを削除" do
      let(:user) { create(:user) }
      let(:knowledge) { create(:knowledge) }

      before do
        knowledge.save
        knowledge.bookmarks.create!(knowledge_id: knowledge.id, user_id: user.id)
      end

      it "紐づくブックマークも削除される" do
        expect { knowledge.destroy }.to change(Bookmark, :count).by(-1)
      end
    end
  end
end
