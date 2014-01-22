TaggitCore::Application.routes.draw do
  get '/auth/github/callback', to: 'sessions#create'
  get '/logout',               to: 'sessions#destroy'

  post '/webhook', to: 'webhook#process_payload'

  namespace :api, defaults: { format: :json } do
    resource :user, only: [:show, :update]

    resources :owners,        only: [:show]
    resources :subscriptions, only: [:create, :destroy]

    resources :repos, id: /.+\/.+/, only: [:index, :show, :update]
  end
end
