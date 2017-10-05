Rails.application.routes.draw do
  get 'channels/create'

  get 'channels/destroy'

  get 'channels/show'

  root to: 'teams#index'

  get '/:slug', to: 'teams#show'
  devise_for :users, :controllers => { registrations: 'registrations' }
  resources :teams  , only: [:create, :destroy]
  resources :team_users, only: [:create, :destroy]
end
