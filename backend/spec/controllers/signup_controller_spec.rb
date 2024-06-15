require "rails_helper"

RSpec.describe Api::V1::SignupController, type: :controller do
  before do
    @request.env["devise.mapping"] = Devise.mappings[:api_v1_user]
  end

  describe "POST #create" do
    context "会員登録完了" do
      let(:valid_params) { { email: "test@example.com", password: "Password1", password_confirmation: "Password1" } }

      before do
        post :create, as: :json, params: valid_params
      end

      it "ステータス200が返却される" do
        expect(response.status).to eq 200
      end

      it "パラメータで指定したユーザーを応援している" do
        json_response = JSON.parse(response.body)
        expect(json_response["data"]["email"]).to eq "test@example.com"
      end
    end

    context "バリデーションエラー(Email形式誤り)" do
      let(:email_type_invalid_params) { { email: "test@com", password: "Password1", password_confirmation: "Password1" } }

      before do
        post :create, as: :json, params: email_type_invalid_params
      end

      it "ステータス422が返却される" do
        expect(response.status).to eq 422
      end

      it "エラーメッセージが返却される" do
        json_response = JSON.parse(response.body)
        expect(json_response["errors"]["full_messages"][0]).to eq "Eメール は有効ではありません"
      end
    end

    context "バリデーションエラー(パスワードが確認用と異なる)" do
      let(:password_different_invalid_params) { { email: "test@example.com", password: "Passowrd3", password_confirmation: "Password1" } }

      before do
        post :create, as: :json, params: password_different_invalid_params
      end

      it "ステータス422が返却される" do
        expect(response.status).to eq 422
      end

      it "エラーメッセージが返却される" do
        json_response = JSON.parse(response.body)
        expect(json_response["errors"]["full_messages"][0]).to eq "パスワード（確認用） が一致しません"
      end
    end

    context "バリデーションエラー(パスワードが短すぎる)" do
      let(:lack_password_invalid_params) { { email: "test@example.com", password: "pass", password_confirmation: "pass" } }

      before do
        post :create, as: :json, params: lack_password_invalid_params
      end

      it "ステータス422が返却される" do
        expect(response.status).to eq 422
      end

      it "エラーメッセージが返却される" do
        json_response = JSON.parse(response.body)
        expect(json_response["errors"]["full_messages"][0]).to eq "パスワード は6文字以上で入力してください"
      end
    end

    context "バリデーションエラー(Email未入力)" do
      let(:email_empty_invalid_params) { { email: "", password: "Password1", password_confirmation: "Password1" } }

      before do
        post :create, as: :json, params: email_empty_invalid_params
      end

      it "ステータス422が返却される" do
        expect(response.status).to eq 422
      end

      it "エラーメッセージが返却される" do
        json_response = JSON.parse(response.body)
        expect(json_response["errors"]["full_messages"][0]).to eq "Eメール を入力してください"
      end
    end

    context "バリデーションエラー(パスワード未入力)" do
      let(:password_empty_invalid_params) { { email: "test@example.com", password: "", password_confirmation: "Password1" } }

      before do
        post :create, as: :json, params: password_empty_invalid_params
      end

      it "ステータス422が返却される" do
        expect(response.status).to eq 422
      end

      it "エラーメッセージが返却される" do
        json_response = JSON.parse(response.body)
        expect(json_response["errors"]["full_messages"][0]).to eq "パスワード を入力してください"
      end
    end

    context "バリデーションエラー(パスワードが長すぎる)" do
      let(:email_empty_invalid_params) { { email: "test@example.com", password: "a" * 5001, password_confirmation: "a" * 5001 } }

      before do
        post :create, as: :json, params: email_empty_invalid_params
      end

      it "ステータス422が返却される" do
        expect(response.status).to eq 422
      end

      it "エラーメッセージが返却される" do
        json_response = JSON.parse(response.body)
        expect(json_response["errors"]["full_messages"][0]).to eq "パスワード は128文字以内で入力してください"
      end
    end
  end

  describe "Delete #destroy" do
    let(:user) { create(:user, :with_knowledges, :with_records, status: 1) }
    let!(:headers) { user.create_new_auth_token }

    context "ゲストユーザー退会" do
      before do
        request.headers.merge!(headers)
        delete :destroy, as: :json
      end

      it "ステータス422が返却される" do
        expect(response.status).to eq 422
      end

      it "エラーメッセージが返却される" do
        json_response = JSON.parse(response.body)
        expect(json_response["errors"]).to eq "ゲストユーザーは削除できません"
      end
    end
  end

  describe "Delete #destroy" do
    let!(:user1) { create(:user, :with_knowledges, :with_records, status: 0) }
    let!(:headers1) { user1.create_new_auth_token }

    context "ユーザー退会" do
      before do
        request.headers.merge!(headers1)
        delete :destroy, as: :json
      end

      it "ステータス200が返却される" do
        expect(response.status).to eq 200
      end

      it "エラーメッセージが返却される" do
        json_response = JSON.parse(response.body)
        expect(json_response["user"]).to eq nil
      end
    end
  end
end
