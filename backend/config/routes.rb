Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      devise_scope :api_v1_user do
        post "users/guest_sign_in", to: "sessions#guest_sign_in"
        get "users/check_login", to: "sessions#check_login"
      end
      mount_devise_token_auth_for "User", at: "auth", controllers: {
        registrations: "api/v1/signup",
        sessions: "api/v1/sessions",
        passwords: "api/v1/passwords"
      }

      resources :records
      delete "/record/image", to: "records#delete_image"

      resources :knowledges
      delete "/knowledge/image", to: "knowledges#delete_image"

      resources :profiles
      resources :bookmarks
      resources :supports
      resources :contacts
      resources :users
      resources :my_records
      resources :user_records
      resources :user_knowledges
      resources :support_counts
      resources :graph_records
      resources :knowledge_comments
      resources :record_comments
    end
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
