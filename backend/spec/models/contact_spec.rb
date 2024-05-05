require 'rails_helper'

RSpec.describe Contact, type: :model do
    describe 'バリデーションチェック' do
        let(:contact) { create(:contact) }
    
        it '登録情報は正しい' do
            expect(contact).to be_valid
        end

        it 'タイトルはnilが許容されていない' do
            contact.content = nil
            expect(contact).to be_invalid
        end

        it '内容は5000文字以上は許容されていない' do
            contact.content = "a" * 5001
            expect(contact).to be_invalid
        end
    end
end