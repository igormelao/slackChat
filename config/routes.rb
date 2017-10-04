Rails.application.routes.draw do
  root to: 'teams#index'

  get '/:slug', to: 'teams#show'
  devise_for :users, :controllers => { registrations: 'registrations' }
  resources :teams  , only: [:create, :destroy]
  resources :team_users, only: [:create, :destroy]
end
