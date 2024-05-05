require 'rails_helper'

RSpec.describe Api::V1::SessionsController, type: :request do
  let(:user) { create(:user) }
    
  describe 'POST #create' do
    context 'ログイン成功' do
        let(:valid_params) { { email: user.email, password: 'Password1' } }
        before do
            post "/api/v1/auth/sign_in", as: :json, params: valid_params
        end
        
        it 'ステータス200が返却される' do
            expect(response.status).to eq 200
        end
        
        it 'headerの情報が付与されている' do
            expect(response.headers['uid']).to eq user.email
            expect(response.headers['access-token']).not_to be nil
        end
    end

    context 'バリデーションエラー(Email形式誤り)' do
        let(:email_type_invalid_params) { { email: 'test@com', password: 'Password1' } }
        before do
          post "/api/v1/auth", as: :json, params: email_type_invalid_params
        end
          
        it 'ステータス422が返却される' do
          expect(response.status).to eq 422
        end
  
        it 'エラーメッセージが返却される' do
          json_response = JSON.parse(response.body)
          expect(json_response['errors']['full_messages'][0]).to eq 'Eメール は有効ではありません'
        end
    end

    context 'バリデーションエラー(パスワードが短すぎる)' do
        let(:lack_password_invalid_params) { { email: 'test@example.com', password: 'pass' } }
        before do
          post "/api/v1/auth", as: :json, params: lack_password_invalid_params
        end
          
        it 'ステータス422が返却される' do
          expect(response.status).to eq 422
        end
  
        it 'エラーメッセージが返却される' do
          json_response = JSON.parse(response.body)
          expect(json_response['errors']['full_messages'][0]).to eq 'パスワード は6文字以上で入力してください'
        end
    end

    context 'バリデーションエラー(Email未入力)' do
        let(:email_empty_invalid_params) { { email: '', password: 'Password1' } }
        before do
            post "/api/v1/auth", as: :json, params: email_empty_invalid_params
        end
          
        it 'ステータス422が返却される' do
          expect(response.status).to eq 422
        end
  
        it 'エラーメッセージが返却される' do
          json_response = JSON.parse(response.body)
          expect(json_response['errors']['full_messages'][0]).to eq 'Eメール を入力してください'
        end
    end
  end
end