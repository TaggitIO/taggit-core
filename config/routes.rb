TaggitCore::Application.routes.draw do
  get '/auth/github/callback', to: 'sessions#create'
  get '/logout',               to: 'sessions#destroy'

  post '/webhook', to: 'webhook#process_payload'

  resource :user, only: [:show, :update]

  resources :owners, only: [:show] do
    resources :repos, only: [:index, :show, :update] do
      resources :subscriptions, only: [:create, :destroy]
    end
  end
end
