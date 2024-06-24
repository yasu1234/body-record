require "rails_helper"

RSpec.describe Comment, type: :model do
  describe "Association" do
    context "ユーザーを削除" do
      let(:user) { create(:user) }

      before do
        user.save
        user.comments.create!(comment: "test", user_id: user.id)
      end

      it "紐づく記事データも削除される" do
        expect { user.destroy }.to change(Comment, :count).by(-1)
      end
    end
  end

  describe "バリデーションチェック" do
    let(:comment) { create(:comment) }

    it "登録情報は正しい" do
      expect(comment).to be_valid
    end

    it "タイトルはnilが許容されていない" do
      comment.user_id = nil
      expect(comment).to be_invalid
    end

    it "コメントは301文字以上は許容されていない" do
      comment.comment = "a" * 301
      expect(comment).to be_invalid
    end
  end
end
