require "rake_helper"

describe "問い合わせ削除バッチテスト" do
  # Rakeタスクの呼び出し
  subject(:task) { Rake.application["contact:destroy"] }

  before do
    create(:contact, status: 1)
    create(:contact, status: 0)
  end

  it "1件削除される" do
    expect { task.invoke }.to change(Contact, :count).by(-1)
  end
end
