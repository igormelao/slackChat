Rails.application.routes.draw do
  get 'talks/show'

  mount ActionCable.server => '/cable'
  root to: 'teams#index'
  get '/:slug', to: 'teams#show'
  resources :teams, only: [:create, :destroy]
  resources :channels, only: [:show, :create, :destroy]
  resources :team_users, only: [:create, :destroy]
  devise_for :users, :controllers => { registrations: 'registrations' }
end
