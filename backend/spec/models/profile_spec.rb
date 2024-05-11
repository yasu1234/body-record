require 'rails_helper'

RSpec.describe Profile, type: :model do
    describe '画像バリデーション' do            
        it { is_expected.to validate_content_type_of(:image).allowing('image/png', 'image/jpg') }
        it { is_expected.to validate_content_type_of(:image).rejecting('text/plain', 'image/pdf') }
      
        it { is_expected.to validate_size_of(:image).less_than(5.megabytes) }
    end

    describe 'Association' do
        context 'ユーザーを削除' do
            let(:user) { create(:user) }
            let(:profile) { create(:profile) }

            before do
                user.build_profile(profile: "test").save!
            end
                  
            it '紐づくプロファイルデータも削除される' do
              expect { user.destroy }.to change(Profile, :count).by(-1)
            end
        end
    end

    describe '#image_urls' do
        context '画像を登録' do
            let(:profile) { create(:profile) }
            let(:image1) { fixture_file_upload('spec/fixtures/image.png', 'image/png') }
        
            before do
                profile.image.attach(image1)
            end
        
            it '登録した画像の情報を取得できる' do
                url = profile.image_url
                expect(url[:url]).to include('http://localhost:3000/rails/active_storage/blobs')
                expect(url[:filename]).to eq('image.png')
            end
        end
    end
end