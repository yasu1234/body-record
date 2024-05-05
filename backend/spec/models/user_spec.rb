require 'rails_helper'

RSpec.describe User, type: :model do
  context 'ユーザーを削除' do
    let(:user) { create(:user) }
    let(:other_user) { create(:user) }

    before do
      user.support(other_user)
    end

    it '紐づく応援データも削除される' do
      expect { user.destroy }.to change(Support, :count).by(-1)
    end
  end

  describe '#guest' do
    it 'ゲストユーザーが作成される' do
      expect { User.guest }.to change { User.count }.by(1)
      guest_user = User.find_by(email: ENV['GUEST_USER_ADDRESS'])
      expect(guest_user).to be_present
      expect(guest_user.name).to eq 'ゲストユーザー'
      expect(guest_user.status).to eq 1
    end
  end

  describe '#support' do
    let(:user) { create(:user) }
    let(:other_user) { create(:user) }

    it '応援ができる' do
      expect { user.support(other_user) }.to change { Support.count }.by(1)
      expect(user.supportings).to include(other_user)
      expect(other_user.supporters).to include(user)
    end

    it '自分が自分を応援できない' do
      expect { user.support(user) }.not_to change { Support.count }
    end
  end

  describe '#removeSupport' do
    let(:user) { create(:user) }
    let(:other_user) { create(:user) }

    before do
      user.support(other_user)
    end

    it '応援解除が行われる' do
      expect { user.removeSupport(other_user) }.to change { Support.count }.by(-1)
      expect(user.supportings).not_to include(other_user)
      expect(other_user.supporters).not_to include(user)
    end
  end
end