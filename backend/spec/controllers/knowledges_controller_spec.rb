require 'rails_helper'

RSpec.describe Api::V1::KnowledgesController, type: :controller do
    let!(:user) { create(:user, :with_knowledges, :without_records) }
    let(:headers) { user.create_new_auth_token }
    let(:image) { file_fixture('image.png') }
    let(:valid_params) { { title: 'テストタイトル', content: 'テストコンテンツ', user_id: user.id, images: [image] } }
    let(:invalid_params) { { title: '', content: 'テストコンテンツ', user_id: user.id } }
    let(:over_content_invalid_params) { { title: 'test', content: "a" * 5001, user_id: user.id } }
    let(:update_valid_params) { { title: 'テストタイトル更新', content: 'テストコンテンツ更新', user_id: user.id, images: [image] } }

    def create_knowledges(count)
        create_list(:knowledge, count, user: user)
    end
  
    describe 'GET #index' do
      context '未ログイン' do
        let!(:knowledge) { create_knowledges(1) }
        before do
            get :index, format: :json
        end
  
        it '401(未認証のステータスコード)' do
            expect(response.status).to eq 401
        end
      end
    end

    describe 'GET #index' do
      context 'ログイン済' do
        let(:user) { create(:user, :without_knowledges, :without_records) }
        let!(:knowledge) { create_knowledges(1) }
        before do
            request.headers.merge!(headers)
            get :index, format: :json
        end
  
        it 'ステータス200が返却される' do
            expect(response.status).to eq 200
        end

        it 'データが1件取得できる' do
            json_response = JSON.parse(response.body)
            expect(json_response['knowledges'].count).to eq 1
            expect(json_response['totalPage']).to eq 1
        end
      end
    end

    describe 'GET #index' do
      context '2ページ目のデータ' do
        let(:user) { create(:user, :without_knowledges, :without_records) }
        let!(:knowledge) { create_knowledges(31) }
        before do
            request.headers.merge!(headers)
            get :index, format: :json, params: { page: 2 }
        end

        it 'ステータス200が返却される' do
            expect(response.status).to eq 200
        end

        it '件数は1件で、合計ページは2' do
            json_response = JSON.parse(response.body)
            expect(json_response['knowledges'].count).to eq 1
            expect(json_response['totalPage']).to eq 2
        end
      end
    end

    describe 'GET #index' do
      context 'データ0件' do
        let(:user) { create(:user, :without_knowledges, :without_records) }
        before do
            request.headers.merge!(headers)
            get :index, format: :json
        end
  
        it 'ステータス200が返却される' do
            expect(response.status).to eq 200
        end

        it '件数は0件で、合計ページは0' do
            json_response = JSON.parse(response.body)
            expect(json_response['knowledges'].count).to eq 0
            expect(json_response['totalPage']).to eq 0
        end
      end
    end

    describe 'GET #index' do
      context 'キーワード検索' do
        let!(:knowledge1) { create(:knowledge, user: user, title: 'KnowTEST', content: 'test1') }
        let!(:knowledge2) { create(:knowledge, user: user, title: 'Knowledge', content: 'test2') }
        let!(:knowledge3) { create(:knowledge, user: user, title: 'Foo', content: 'test3') }
        before do
            request.headers.merge!(headers)
            get :index, format: :json, params: { keyword: 'Know' }
        end
  
        it 'ステータス200が返却される' do
            expect(response.status).to eq 200
        end

        it '件数は2件で、合計ページは1' do
            json_response = JSON.parse(response.body)
            expect(json_response['knowledges'].count).to eq 2
            expect(json_response['totalPage']).to eq 1
        end
      end
    end

    describe 'POST #create' do
      context '未ログイン' do
        before do
            post :create, format: :json, params: valid_params
        end
  
        it '401(未認証のステータスコード)' do
            expect(response.status).to eq 401
        end
      end
    end

    describe 'POST #create' do
        context '作成完了' do
            before do
                request.headers.merge!(headers)
                post :create, format: :json, params: { knowledge: valid_params }
            end

            it '1件データが追加' do
                expect(change(Knowledge, :count).by(1))
                expect(response.status).to eq 200
            end
    
            it '入力した値で登録できている' do
                jsonResponse = JSON.parse(response.body)
                expect(jsonResponse["knowledge"]["title"]).to eq('テストタイトル')
                expect(jsonResponse["knowledge"]["content"]).to eq('テストコンテンツ')
                expect(jsonResponse["knowledge"]["user_id"]).to eq(user.id)
            end
        end
    end

    describe 'POST #create' do
        context 'バリデーションエラー(タイトル不足)' do
            before do
                request.headers.merge!(headers)
                post :create, format: :json, params: { knowledge: invalid_params }
            end

            it 'データが追加されない' do
                expect(change(Knowledge, :count).by(0))
            end
    
            it 'ステータス422が返却される' do
                expect(response.status).to eq 422
            end
        end
    end

    describe 'POST #create' do
        context 'バリデーションエラー(内容の文字数オーバー)' do
            before do
                request.headers.merge!(headers)
                post :create, format: :json, params: { knowledge: over_content_invalid_params }
            end

            it 'データが追加されない' do
                expect(change(Knowledge, :count).by(0))
            end
    
            it 'ステータス422が返却される' do
                expect(response.status).to eq 422
            end
        end
    end

    describe 'GET #show' do
      context '未ログイン' do
        let!(:knowledge) { create_knowledges(1).first }
        before do
            get :show,  params: { id: knowledge.id }, format: :json
        end
  
        it '401(未認証のステータスコード)' do
            expect(response.status).to eq 401
        end
      end
    end

    describe 'GET #show' do
      context 'ID不足' do
        let(:knowledge) { create_knowledges(1).first }
        before do
            request.headers.merge!(headers)
            get :show,  params: { id: '' }, format: :json
        end
  
        it '404のエラー' do
            expect(response.status).to eq 404
        end
      end
    end

    describe 'GET #show' do
      context '対象のデータが存在しない' do
        let(:knowledge) { create(:knowledge, title: 'テストタイトル', content: 'テストコンテンツ', user_id: user.id, id: 1) }
        before do
            request.headers.merge!(headers)
            get :show,  params: { id: 150 }, format: :json
        end
  
        it '404のエラー' do
            expect(response.status).to eq 404
        end
      end
    end

    describe 'GET #show' do
      context '対象のデータを取得できる' do
        let(:knowledge) { create(:knowledge, user: user) }
        before do
            request.headers.merge!(headers)
            get :show,  params: { id: knowledge.id }, format: :json
        end
  
        it 'ステータス200が返却される' do
            expect(response.status).to eq 200
        end

        it 'ステータス200が返却される' do
            jsonResponse = JSON.parse(response.body)
            expect(jsonResponse["knowledge"]["title"]).to eq('サンプルタイトル')
            expect(jsonResponse["knowledge"]["content"]).to eq('サンプルコンテンツ')
            expect(jsonResponse["knowledge"]["user_id"]).to eq(user.id)
            expect(jsonResponse["knowledge"]["id"]).to eq(knowledge.id)
        end
      end
    end

    describe 'PATCH #update' do
      context '未ログイン' do
        let(:knowledge) { create(:knowledge, title: 'テストタイトル', content: 'テストコンテンツ', user_id: user.id, id: 1) }
        before do
            patch :update, params: { id: 1, knowledge: valid_params }
        end
  
        it '401(未認証のステータスコード)エラー' do
            expect(response.status).to eq 401
        end
      end
    end

    describe 'PATCH #update' do
      context '対象のデータが存在しない' do
        before do
            request.headers.merge!(headers)
            put :update, params: { id: -1, knowledge: valid_params }
        end
  
        it '404のエラー' do
            expect(response.status).to eq 404
        end
      end
    end

    describe 'PUT #update' do
        context 'バリデーションエラー(タイトル不足)' do
            before do
                request.headers.merge!(headers)
                put :update, params: { id: user.knowledges.first.id, knowledge: { title: '' } }
            end
    
            it 'ステータス422が返却される' do
                expect(response.status).to eq 422
            end
        end
    end

    describe 'PATCH #update' do
        context 'バリデーションエラー(内容の文字数オーバー)' do
            before do
                request.headers.merge!(headers)
                put :update, params: { id: user.knowledges.first.id, knowledge: over_content_invalid_params }
            end
    
            it 'ステータス422が返却される' do
                expect(response.status).to eq 422
            end
        end
    end

    describe 'PATCH #update' do
        context '更新完了' do
            before do
                request.headers.merge!(headers)
                patch :update, format: :json, params: { id:  user.knowledges.first.id, knowledge: update_valid_params }
            end

            it '1件データが追加' do
                expect(change(Knowledge, :count).by(0))
                expect(response.status).to eq 200
            end
    
            it '入力した値で更新できている' do
                jsonResponse = JSON.parse(response.body)
                expect(jsonResponse["knowledge"]["title"]).to eq('テストタイトル更新')
                expect(jsonResponse["knowledge"]["content"]).to eq('テストコンテンツ更新')
                expect(jsonResponse["knowledge"]["user_id"]).to eq(user.id)
            end
        end
    end

    describe 'DELETE #destroy' do
        context '未ログイン' do
          before do
              delete :destroy, params: { id: user.knowledges.first.id }, format: :json
          end
    
          it '401(未認証のステータスコード)エラー' do
              expect(response.status).to eq 401
          end
        end
    end

    describe 'DELETE #destroy' do
        context 'ID 不足' do
          before do
              request.headers.merge!(headers)
              delete :destroy, params: { id: '' }, format: :json
          end
    
          it '404のエラー' do
              expect(response.status).to eq 404
          end
        end
    end

    describe 'DELETE #destroy' do
      context '対象のデータが存在しない' do
        before do
            request.headers.merge!(headers)
            delete :destroy, params: { id: -1 }, format: :json
        end
  
        it '404のエラー' do
            expect(response.status).to eq 404
        end
      end
    end

    describe 'DELETE #destroy' do
      context '削除成功' do
        before do
            request.headers.merge!(headers)
            delete :destroy, params: { id: user.knowledges.first.id }, format: :json
        end
  
        it '1件データが削除' do
            expect(change(Knowledge, :count).by(-1))
        end
        it 'ステータス200' do
            expect(response.status).to eq 200
        end
      end
    end

    describe 'GET #get_target_user_knowledge' do
    context 'ユーザーのデータ5件' do
      before do
          request.headers.merge!(headers)
          get 'get_target_user_knowledge', params: { user_id: user.id }, format: :json
      end

      it 'ステータス200' do
          expect(response.status).to eq 200
      end

      it 'データは5件分取得' do
        json_response = JSON.parse(response.body)
        expect(json_response['knowledges'].count).to eq 5
      end
    end

    describe 'GET #get_target_user_knowledge' do
      context '成功(対象のユーザーがいない)' do
        before do
            request.headers.merge!(headers)
            get 'get_target_user_knowledge', params: { user_id: -1 }, format: :json
        end
  
        it 'ステータス200' do
            expect(response.status).to eq 200
        end
  
        it 'データは0件' do
          json_response = JSON.parse(response.body)
          expect(json_response['knowledges'].count).to eq 0
        end
      end
    end

    describe 'GET #get_target_user_knowledge' do
      context 'ユーザーのデータ7件' do
          let(:user) { create(:user, :with_knowledges_over, :without_records) }
          before do
            request.headers.merge!(headers)
            get 'get_target_user_knowledge', params: { user_id: user.id }, format: :json
        end
  
        it 'ステータス200' do
            expect(response.status).to eq 200
        end
  
        it 'データは5件分取得' do
          json_response = JSON.parse(response.body)
          expect(json_response['knowledges'].count).to eq 5
        end
      end
    end
  end
end