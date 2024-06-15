require 'rails_helper'

RSpec.describe Api::V1::PasswordsController, type: :controller do
  before do
    @request.env["devise.mapping"] = Devise.mappings[:api_v1_user]
  end

  describe "PATCH #update" do
    context "ゲストユーザーがパスワード更新を行う" do
      let(:user) { create(:user, status: 1) }
      let(:headers) { user.create_new_auth_token }

      before do
        request.headers.merge!(headers)
        put :update, params: { password: 'new_password', password_confirmation: 'new_password' }
      end

      it "ステータス422が返却される" do
        expect(response.status).to eq 422
      end

      it "エラーメッセージが返却される" do
        expect(JSON.parse(response.body)['errors']).to eq 'ゲストユーザーはパスワード変更できません'
      end
    end

    context "一般ユーザーがパスワード更新を試みた場合" do
      let(:user1) { create(:user, status: 0) }
      let(:headers) { user1.create_new_auth_token }

      context "パスワードが正しい場合" do
        before do
          request.headers.merge!(headers)
          put :update, params: { password: 'new_password', password_confirmation: 'new_password', current_password: user1.password }
        end

        it "ステータス200が返却される" do
          expect(response.status).to eq 200
        end

        it "ユーザー情報が存在する" do
            json_response = JSON.parse(response.body)
            expect(json_response["user"]).to be_present
        end
      end

      context "現在のパスワードが間違っている場合" do
        before do
          request.headers.merge!(headers)
          patch :update, params: { password: 'new_password', password_confirmation: 'new_password', current_password: 'wrong_password' }
        end

        it "ステータス422が返却される" do
          expect(response.status).to eq 422
        end

        it "エラーメッセージが返却される" do
          expect(JSON.parse(response.body)['errors'][0]).to eq '現在のパスワード は不正な値です'
        end
      end
    end
  end
end
