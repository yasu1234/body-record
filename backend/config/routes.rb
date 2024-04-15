Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      devise_scope :api_v1_user do
        post 'users/guest_sign_in', to: 'sessions#guest_sign_in'
        get 'users/check_login', to: 'sessions#chck_login'
      end
      mount_devise_token_auth_for 'User', at: 'auth', controllers: {
        registrations: 'api/v1/signup',
        sessions: 'api/v1/sessions'
      }
      resources :records
      get '/myRecord', to: 'records#searchMyRecord'
      delete '/record/image', to: 'records#delete_image'

      resources :knowledges
      delete '/knowledge/image', to: 'knowledges#delete_image'
    end
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
