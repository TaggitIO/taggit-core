TaggitCore::Application.routes.draw do
  root to: 'main#index'

  get '/auth/github/callback', to: 'sessions#create'
  get '/auth/logout',          to: 'sessions#destroy'

  namespace :api, defaults: { format: :json } do
    post '/webhook', to: 'webhook#process_payload'

    # Users is a collection resource because Ember doesn't handle singletons.
    resources :users, only: [:show, :update] do
      post 'sync', on: :member
    end

    resources :owners,        only: [:show]
    resources :subscriptions, only: [:create, :destroy]

    resources :repos, id: /.+\/.+/, only: [:index, :show, :update]
  end
end
