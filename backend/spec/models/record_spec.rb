require 'rails_helper'

RSpec.describe Record, type: :model do
    describe 'Association' do
        context 'ユーザーを削除' do
            let(:user) { create(:user) }

            before do
                user.save
                user.records.create!(date: "2024/04/29")
            end
                  
            it '紐づくノウハウデータも削除される' do
              expect { user.destroy }.to change(Record, :count).by(-1)
            end
        end
    end

    describe '画像バリデーション' do            
        it { is_expected.to validate_content_type_of(:images).allowing('image/png', 'image/jpg') }
        it { is_expected.to validate_content_type_of(:images).rejecting('text/plain', 'image/pdf') }
      
        it { is_expected.to validate_size_of(:images).less_than(5.megabytes) }
    end

    describe 'バリデーションチェック' do
        let(:record) { create(:record) }
    
        it '登録情報は正しい' do
            expect(record).to be_valid
        end

        it '記録日は必須' do
            record.date = nil
            expect(record).to be_invalid
        end
    end
end